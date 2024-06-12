import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ex03/redux/state.dart';
import '../models/models.dart';
import '../redux/actions.dart'; // Import your actions file

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final person = ModalRoute.of(context)?.settings.arguments;
    var tmpId = 0;
    final store = StoreProvider.of<AppState>(context);
    final _id = TextEditingController();
    final _title = TextEditingController();
    final _url = TextEditingController();
    if (person is Person) {
      tmpId = person.id;
      _id.text = person.id.toString();
      _title.text = person.title;
      _url.text = person.url;
    }

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
              store.dispatch(EditPersonAction(
                  id: tmpId,
                  person: Person(
                      id: int.parse(_id.text),
                      title: _title.text,
                      url: _url.text,
                      imageData: null,
                      isLoading: false)));
            },
            child: const Text("edit"),
          ),
        ],
      ),
    );
  }
}
