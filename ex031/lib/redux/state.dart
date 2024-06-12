import 'package:ex031/models/models.dart';
import 'package:flutter/material.dart';

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
