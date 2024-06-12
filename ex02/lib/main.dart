import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

const apiUrl = "http://localhost:8888/photos";

@immutable
class Person {
  final int id;
  final String title;
  final String url;
  final Uint8List? imageData;
  final bool isLoading;

  Person copieWith([
    bool? isLoading,
    Uint8List? imageData,
  ]) =>
      Person(
        id: id,
        title: title,
        url: url,
        imageData: imageData ?? this.imageData,
        isLoading: isLoading ?? this.isLoading,
      );

  const Person(
      {required this.id,
      required this.title,
      required this.url,
      required this.imageData,
      required this.isLoading});

  Person.fromJson(Map<String, dynamic> json)
      : id = json["id"] as int,
        title = json["title"] as String,
        url = json["url"] as String,
        imageData = null,
        isLoading = false;

  @override
  String toString() {
    return "Person ( $id , $title)";
  }
}

Future<Iterable<Person>> getPersons() => HttpClient()
    .getUrl(Uri.parse(apiUrl))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
abstract class Action {
  const Action();
}

@immutable
class LoadPeopleAction extends Action {
  const LoadPeopleAction();
}

@immutable
class SuccessfullyFetchedPeopleAction extends Action {
  final Iterable<Person> persons;
  const SuccessfullyFetchedPeopleAction({required this.persons});
}

@immutable
class FailedToFetchPeopleAction extends Action {
  final Object error;
  const FailedToFetchPeopleAction({required this.error});
}

@immutable
class AppState {
  final bool isLoading;
  final Iterable<Person>? fetchedPersons;
  final Object? error;

  Iterable<Person>? get sortedFetchedPersons =>
      fetchedPersons?.toList()?..sort((p1, p2) => p1.id.compareTo(p2.id));

  const AppState({
    required this.isLoading,
    required this.fetchedPersons,
    required this.error,
  });

  const AppState.empty()
      : isLoading = false,
        fetchedPersons = null,
        error = null;
}

@immutable
class LoadPersonImageAction extends Action {
  final int id;
  const LoadPersonImageAction({required this.id});
}

@immutable
class SuccessfullyLoadedPersonImageAction extends Action {
  final int id;
  final Uint8List imageData;

  const SuccessfullyLoadedPersonImageAction({
    required this.id,
    required this.imageData,
  });
}

AppState reducer(AppState oldState, action) {
  if (action is SuccessfullyLoadedPersonImageAction) {
    final person = oldState.fetchedPersons?.firstWhere(
      (p) => p.id == action.id,
    );
    if (person != null) {
      return AppState(
        error: oldState.error,
        isLoading: false,
        fetchedPersons: oldState.fetchedPersons
            ?.where((p) => p.id != person.id)
            .followedBy([person.copieWith(false, action.imageData)]),
      );
    } else {
      // person is null
      return oldState;
    }
  } else if (action is LoadPersonImageAction) {
    final person = oldState.fetchedPersons?.firstWhere(
      (p) => p.id == action.id,
    );
    if (person != null) {
      return AppState(
        error: oldState.error,
        isLoading: false,
        fetchedPersons: oldState.fetchedPersons
            ?.where((p) => p.id != person.id)
            .followedBy([person.copieWith(true)]),
      );
    } else {
      // person is null
      return oldState;
    }
  } else if (action is LoadPeopleAction) {
    return const AppState(
      error: null,
      fetchedPersons: null,
      isLoading: true,
    );
  } else if (action is SuccessfullyFetchedPeopleAction) {
    return AppState(
      error: null,
      fetchedPersons: action.persons,
      isLoading: false,
    );
  } else if (action is FailedToFetchPeopleAction) {
    return AppState(
      error: action.error,
      fetchedPersons: oldState.fetchedPersons,
      isLoading: false,
    );
  }
  return oldState;
}

void loadPeopleMiddleware(
  Store<AppState> store,
  action,
  NextDispatcher next,
) {
  if (action is LoadPeopleAction) {
    getPersons().then((persons) {
      store.dispatch(SuccessfullyFetchedPeopleAction(persons: persons));
    }).catchError((e) {
      store.dispatch(FailedToFetchPeopleAction(error: e));
    });
  }
  next(action);
}

void loadPersonImageMiddleware(
  Store<AppState> store,
  action,
  NextDispatcher next,
) {
  if (action is LoadPersonImageAction) {
    final person =
        store.state.fetchedPersons?.firstWhere((p) => p.id == action.id);
    if (person != null) {
      final url = person.url;
      final bundle = NetworkAssetBundle(Uri.parse(url));
      bundle.load(url).then((bd) => bd.buffer.asUint8List()).then((data) {
        store.dispatch(
          SuccessfullyLoadedPersonImageAction(
            id: person.id,
            imageData: data,
          ),
        );
      });
    }
  }
  next(action);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Store(
      reducer,
      initialState: const AppState.empty(),
      middleware: [
        loadPeopleMiddleware,
        loadPersonImageMiddleware,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StoreProvider(
        store: store,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                store.dispatch(const LoadPeopleAction());
              },
              child: const Text('Load persons'),
            ),
            StoreConnector<AppState, bool>(
              converter: (store) => store.state.isLoading,
              builder: (context, isLoading) {
                if (isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const SizedBox();
                }
              },
            ),
            StoreConnector<AppState, Iterable<Person>?>(
              converter: (store) => store.state.sortedFetchedPersons,
              builder: (context, people) {
                if (people == null) {
                  return const SizedBox();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      final person = people.elementAt(index);

                      final infoWidget = Text('${person.id} years old');

                      final Widget subtitle = person.imageData == null
                          ? infoWidget
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoWidget,
                                Image.memory(person.imageData!)
                              ],
                            );

                      final Widget trailing = person.isLoading
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: () {
                                store.dispatch(
                                  LoadPersonImageAction(id: person.id),
                                );
                              },
                              child: const Text('Load image'),
                            );

                      return ListTile(
                        title: Text(person.title),
                        subtitle: subtitle,
                        trailing: trailing,
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
