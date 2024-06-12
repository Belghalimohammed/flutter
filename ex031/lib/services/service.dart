import 'dart:convert';
import 'dart:io';
import 'package:ex031/models/models.dart';

const apiUrl = "http://localhost:8888/photos";

Future<Iterable<Person>> getPersons() => HttpClient()
    .getUrl(Uri.parse(apiUrl))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));
