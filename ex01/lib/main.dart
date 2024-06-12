import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(const MyApp());
}

// Enum for filtering items
enum ItemFilter { all, long, short }

// Immutable class representing the app state
@immutable
class AppState {
  final Iterable<String> items; // List of items
  final ItemFilter filter; // Current filter

  const AppState({
    required this.items,
    required this.filter,
  });

  // Filtered items based on current filter
  Iterable<String> get filteredItems {
    switch (filter) {
      case ItemFilter.all:
        return items;
      case ItemFilter.long:
        return items.where((e) => e.length >= 5); // Filtering long items
      case ItemFilter.short:
        return items.where((e) => e.length <= 3); // Filtering short items
    }
  }
}

// Base class for actions
@immutable
abstract class Action {
  const Action();
}

// Action to change filter type
@immutable
class ChangeFilterTypeAction extends Action {
  final ItemFilter filter;
  const ChangeFilterTypeAction(this.filter);
}

// Base class for item-related actions
@immutable
abstract class ItemAction extends Action {
  final String item;
  const ItemAction(this.item);
}

// Action to add an item
@immutable
class AddItemAction extends ItemAction {
  const AddItemAction(super.item);
}

// Action to remove an item
@immutable
class RemoveItemAction extends ItemAction {
  const RemoveItemAction(super.item);
}

// Extension for adding and removing items from Iterable
extension AddRemoveItems<T> on Iterable<T> {
  Iterable<T> operator +(T other) => followedBy([other]);
  Iterable<T> operator -(T other) => where((element) => element != other);
}

// Reducer for adding items
Iterable<String> addItemReducer(
  Iterable<String> previousItems,
  AddItemAction action,
) =>
    previousItems + action.item;

// Reducer for removing items
Iterable<String> removeItemReducer(
  Iterable<String> previousItems,
  RemoveItemAction action,
) =>
    previousItems - action.item;

// Combined reducer for items
Reducer<Iterable<String>> itemsReducer = combineReducers<Iterable<String>>([
  TypedReducer<Iterable<String>, AddItemAction>(addItemReducer).call,
  TypedReducer<Iterable<String>, RemoveItemAction>(removeItemReducer).call,
]);

// Reducer for item filter
ItemFilter itemFilterReducer(
  AppState oldState,
  Action action,
) {
  if (action is ChangeFilterTypeAction) {
    return action.filter;
  } else {
    return oldState.filter;
  }
}

// Reducer for entire app state
AppState appStateReducer(
  AppState oldState,
  action,
) =>
    AppState(
        items: itemsReducer(oldState.items, action),
        filter: itemFilterReducer(oldState, action));

// Root widget for the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scaffold App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

// Home page widget with stateful functionality
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State for the home page widget
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final store = Store(
      appStateReducer,
      initialState: const AppState(
        items: [],
        filter: ItemFilter.all,
      ),
    );
    final _text = TextEditingController();

    @override
    void dispose() {
      super.dispose();
      _text.dispose();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Scaffold App'),
        ),
        body: StoreProvider(
          store: store,
          child: Column(
            children: [
              Row(
                children: [
                  // Buttons to change item filter
                  TextButton(
                    onPressed: () {
                      store.dispatch(
                          const ChangeFilterTypeAction(ItemFilter.all));
                    },
                    child: const Text("all"),
                  ),
                  TextButton(
                    onPressed: () {
                      store.dispatch(
                          const ChangeFilterTypeAction(ItemFilter.short));
                    },
                    child: const Text("short"),
                  ),
                  TextButton(
                    onPressed: () {
                      store.dispatch(
                          const ChangeFilterTypeAction(ItemFilter.long));
                    },
                    child: const Text("long"),
                  )
                ],
              ),
              // Text field for adding items
              TextField(controller: _text),
              Row(
                children: [
                  // Button to add item
                  TextButton(
                    onPressed: () {
                      final text = _text.text;
                      store.dispatch(AddItemAction(text));
                      _text.clear();
                    },
                    child: const Text("add"),
                  ),
                  // Button to remove item
                  TextButton(
                    onPressed: () {
                      final text = _text.text;
                      store.dispatch(RemoveItemAction(text));
                      _text.clear();
                    },
                    child: const Text("remove"),
                  ),
                ],
              ),
              // Displaying filtered items
              StoreConnector<AppState, Iterable<String>>(
                converter: (store) => store.state.filteredItems,
                builder: (context, items) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items.elementAt(index);
                      return ListTile(
                        title: Text(item),
                      );
                    },
                  ));
                },
              )
            ],
          ),
        ));
  }
}
