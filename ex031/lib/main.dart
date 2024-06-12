import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ex031/redux/state.dart';
import 'package:ex031/pages/home_page.dart'; // Import your HomePage
import 'package:ex031/redux/middleware.dart';
import 'package:ex031/redux/reducers.dart';

void main() {
  final store = Store(
    reducer,
    initialState: const AppState.empty(),
    middleware: [
      loadPeopleMiddleware,
      loadPersonImageMiddleware,
    ],
  );

  runApp(
    StoreProvider(
      store: store,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(), // Use HomePage as the initial route
    );
  }
}
