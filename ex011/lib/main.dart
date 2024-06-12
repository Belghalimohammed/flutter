import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(const MyApp());
}

@immutable
class AppState {
  final Iterable<String> items;
  final FilterType filter;

  const AppState({
    required this.items,
    required this.filter,
  });

  Iterable<String> get filterItems {
    if (filter == FilterType.all) {
      return items;
    } else if (filter == FilterType.short) {
      return items.where((e) => e.length < 8);
    } else if (filter == FilterType.long) {
      return items.where((e) => e.length >= 8);
    }
    return items;
  }
}

enum FilterType { all, short, long }

@immutable
abstract class Action {
  const Action();
}

@immutable
class FilterAction extends Action {
  final FilterType filer;

  const FilterAction({required this.filer});
}

@immutable
class AddAction extends Action {
  final String item;
  const AddAction({required this.item});
}

@immutable
class DeleteAction extends Action {
  final String item;
  const DeleteAction({required this.item});
}

FilterType filterReducer(
  FilterType oldFilter,
  action,
) {
  if (action is FilterAction) {
    return action.filer;
  } else {
    return oldFilter;
  }
}

Iterable<String> addDeleteReducer(
  Iterable<String> previousItems,
  action,
) {
  if (action is AddAction) {
    return previousItems.followedBy([action.item]);
  } else if (action is DeleteAction) {
    return previousItems.where((e) => e != action.item);
  }
  return previousItems;
}

AppState stateReducer(
  AppState oldState,
  action,
) =>
    AppState(
      items: addDeleteReducer(oldState.items, action),
      filter: filterReducer(oldState.filter, action),
    ); // Root widget for the application

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
    final _text = TextEditingController();
    final store = Store(stateReducer,
        initialState:
            const AppState(items: ["aaa", "bbbb"], filter: FilterType.all));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Scaffold App'),
      ),
      body: StoreProvider(
        store: store,
        child: Column(
          children: [
            TextField(
              controller: _text,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    store.dispatch(const FilterAction(filer: FilterType.all));
                  },
                  child: const Text("all"),
                ),
                TextButton(
                  onPressed: () {
                    store.dispatch(const FilterAction(filer: FilterType.short));
                  },
                  child: const Text("short"),
                ),
                TextButton(
                  onPressed: () {
                    store.dispatch(const FilterAction(filer: FilterType.long));
                  },
                  child: const Text("long"),
                ),
                TextButton(
                  onPressed: () {
                    final item = _text.text;
                    store.dispatch(AddAction(item: item));
                  },
                  child: const Text("add"),
                ),
                TextButton(
                  onPressed: () {
                    final item = _text.text;
                    store.dispatch(DeleteAction(item: item));
                  },
                  child: const Text("delete"),
                ),
              ],
            ),
            StoreConnector<AppState, Iterable<String>>(
                converter: (store) => store.state.filterItems,
                builder: (context, items) {
                  print(items);
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
                })
          ],
        ),
      ),
    );
  }
}
