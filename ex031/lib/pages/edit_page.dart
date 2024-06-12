import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ex031/redux/state.dart';
import '../models/models.dart';
import '../redux/actions.dart'; // Import your actions file

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Person? person =
        ModalRoute.of(context)?.settings.arguments as Person?;
    var tmpId = 0;
    final store = StoreProvider.of<AppState>(context);
    final _id = TextEditingController();
    final _title = TextEditingController();
    final _url = TextEditingController();

    if (person != null) {
      tmpId = person.id;
      _id.text = person.id.toString();
      _title.text = person.title;
      _url.text = person.url;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _id,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _url,
              decoration: const InputDecoration(labelText: 'URL'),
            ),
            const SizedBox(height: 20),
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
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
