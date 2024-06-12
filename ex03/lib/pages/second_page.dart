import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ex03/redux/state.dart';
import '../models/models.dart';
import '../redux/actions.dart'; // Import your actions file

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final _id = TextEditingController();
    final _title = TextEditingController();
    final _url = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _id,
          ),
          TextField(
            controller: _title,
          ),
          TextField(
            controller: _url,
          ),
          TextButton(
            onPressed: () {
              store.dispatch(AddPersonAction(
                  person: Person(
                      id: int.parse(_id.text),
                      title: _title.text,
                      url: _url.text,
                      imageData: null,
                      isLoading: false)));
            },
            child: const Text("add"),
          ),
        ],
      ),
    );
  }
}
