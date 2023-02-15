import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/people.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Box box;
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final peopleListNotifier = ValueNotifier<List<People>>([]);

  @override
  void initState() {
    super.initState();
    box = Hive.box('peopleBox');
  }

  @override
  void dispose() {
    Hive.close();
    nameController.clear();
    countryController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, box, _) {
              if (box.isEmpty) {
                return const Center(child: Text('Add a contact'));
              } else {
                return ListView.separated(
                  itemCount: box.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    onLongPress: () => updateDetails(context, box, index),
                    onTap: () => showDetails(context, box, index),
                    title: Text(box.getAt(index).name),
                    subtitle: Text(box.getAt(index).country),
                    trailing: IconButton(
                      onPressed: () => deletePeople(index),
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: addDetails,
            child: const Icon(Icons.add),
          ),
        ),
      );

  void showDetails(BuildContext context, Box<dynamic> box, int index) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Person Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(box.getAt(index).name),
              Text(box.getAt(index).country),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  void addDetails() async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController),
              TextField(controller: countryController),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                addPeople(
                  nameController.text.trim(),
                  countryController.text.trim(),
                );
                nameController.clear();
                countryController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

  void updateDetails(BuildContext context, Box box, int index) {
    nameController.text = box.getAt(index).name;
    countryController.text = box.getAt(index).country;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController),
            TextField(controller: countryController),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              updatePeople(
                nameController.text.trim(),
                countryController.text.trim(),
                box,
                index,
              );
              nameController.clear();
              countryController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void addPeople(String name, String country) {
    final newPerson = People(
      name: name,
      country: country,
    );

    if (!newPerson.existsInList(box.values)) {
      box.add(newPerson);
    }
  }

  void updatePeople(String name, String country, Box box, int index) {
    final newPerson = People(
      name: name,
      country: country,
    );

    if (!newPerson.existsInList(box.values)) {
      box.putAt(index, newPerson);
    }
  }

  void deletePeople(int index) {
    box.deleteAt(index);
    box.delete("$index");
  }
}
