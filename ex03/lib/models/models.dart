import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  const Person({
    required this.id,
    required this.title,
    required this.url,
    required this.imageData,
    required this.isLoading,
  });

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
