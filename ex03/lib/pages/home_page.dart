import 'package:ex03/pages/edit_page.dart';
import 'package:ex03/pages/second_page.dart';
import 'package:ex03/redux/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/actions.dart';
import '../models/models.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              store.dispatch(const LoadPeopleAction());
            },
            child: const Text('Load persons'),
          ),
          StoreConnector<AppState, bool>(
            converter: (store) => store.state.isLoading,
            builder: (context, isLoading) {
              if (isLoading) {
                return const CircularProgressIndicator();
              } else {
                return const SizedBox();
              }
            },
          ),
          StoreConnector<AppState, Iterable<Person>?>(
            converter: (store) => store.state.sortedFetchedPersons,
            builder: (context, people) {
              if (people == null) {
                return const SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: people.length,
                  itemBuilder: (context, index) {
                    final person = people.elementAt(index);

                    final infoWidget = Text('${person.id} years old');

                    final Widget subtitle = person.imageData == null
                        ? infoWidget
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infoWidget,
                              Image.memory(person.imageData!)
                            ],
                          );

                    final Widget trailing = person.isLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () {
                              store.dispatch(
                                LoadPersonImageAction(id: person.id),
                              );
                            },
                            child: const Text('Load image'),
                          );

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (_) {
                        store.dispatch(SelectPerson(person: person));
                        //   final person = people.elementAt(index);
                        // final person = people.elementAt(index);
                        store.dispatch(DeletePersonAction(id: person.id));
                      },
                      child: ListTile(
                        title: Text(person.title),
                        subtitle: subtitle,
                        trailing: trailing,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditPage(),
                              settings: RouteSettings(
                                arguments: person,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondPage()),
              );
            },
            child: const Text('Go to Second Page'),
          ),
          StoreConnector<AppState, Iterable<Person>?>(
            builder: (context, selectedPeople) {
              return Text(selectedPeople!.length.toString());
            },
            converter: (store) => store.state.selectedPeople,
          )
        ],
      ),
    );
  }
}
