import 'dart:typed_data';

import 'package:ex03/models/models.dart';
import 'package:flutter/material.dart';

@immutable
abstract class Action {
  const Action();
}

@immutable
class LoadPeopleAction extends Action {
  const LoadPeopleAction();
}

@immutable
class AddPersonAction extends Action {
  final Person person;

  const AddPersonAction({required this.person});
}

@immutable
class SelectPerson extends Action {
  final Person person;

  const SelectPerson({required this.person});
}

@immutable
class DeletePersonAction extends Action {
  final int id;

  const DeletePersonAction({required this.id});
}

@immutable
class EditPersonAction extends Action {
  final int id;
  final Person person;

  const EditPersonAction({required this.id, required this.person});
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
