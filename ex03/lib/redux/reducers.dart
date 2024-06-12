import 'package:ex03/models/models.dart';
import 'package:ex03/redux/state.dart';

import 'actions.dart';

AppState reducer(AppState oldState, action) {
  if (action is EditPersonAction) {
    return AppState(
      isLoading: false,
      fetchedPersons: oldState.fetchedPersons?.map((e) {
        if (e.id == action.id) {
          return Person(
            id: action.person.id,
            title: action.person.title,
            url: action.person.url,
            imageData: e.imageData,
            isLoading: e.isLoading,
          );
        }
        return e;
      }),
      error: oldState.error,
    );
  } else if (action is DeletePersonAction) {
    return AppState(
      isLoading: false,
      fetchedPersons: oldState.fetchedPersons?.where((e) => e.id != action.id),
      error: oldState.error,
    );
  } else if (action is AddPersonAction) {
    final person = action.person;
    return AppState(
      isLoading: false,
      fetchedPersons: oldState.fetchedPersons?.followedBy([person]),
      error: oldState.error,
    );
  } else if (action is SuccessfullyLoadedPersonImageAction) {
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
