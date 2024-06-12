import 'package:ex031/redux/state.dart';
import 'package:ex031/services/service.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'actions.dart';

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
