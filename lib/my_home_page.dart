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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: ElevatedButton(
            onPressed: () => addPeople('aku', 'contry'),
            child: const Text('x'),
          ),
        ),
        body: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, box, _) {
              if (box.isEmpty) {
                return const Center(
                  child: Text('Add a contact'),
                );
              } else {
                return ListView.separated(
                  itemCount: box.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                        onTap: () => _showDetails(context, box, i),
                        title: Text(box.getAt(i).name),
                        subtitle: Text(box.getAt(i).country),
                        trailing: IconButton(
                          onPressed: () => _deleteInfo(i),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ));
                  },
                  separatorBuilder: (context, i) => const Divider(),
                );
              }
            }),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _addInfo,
              child: Text('Add'),
            ),
            // ElevatedButton(
            //   onPressed: _getInfo,
            //   child: Text('Get'),
            // ),
            // ElevatedButton(
            //   onPressed: _updateInfo,
            //   child: Text('Update'),
            // ),
            // ElevatedButton(
            //   onPressed: _deleteInfo,
            //   child: Text('Delete'),
            // ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDetails(BuildContext context, Box<dynamic> box, int i) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Person Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(box.getAt(i).name),
                Text(box.getAt(i).country),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _addInfo() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void addPeople(name, country) {
    People newPerson = People(
      name: nameController.text,
      country: countryController.text,
    );
    if (!newPerson.existsInList(box.values)) {
      box.add(newPerson);
    }
  }

  _getInfo() {
    // final peopleList = <People>[];

    // for (People person in box.get('peopleList')) {
    //   if (!peopleList.contains(person)) {
    //     peopleList.add(person);
    //   }
    //   print(person.toString());
    // }
    // peopleListNotifier.value = peopleList;
  }

  _updateInfo() {
    // final peopleList = <People>[];
    // peopleList.add(People(name: 'aku', country: 'India'));
    // box.put('peopleList', peopleList);
    // peopleListNotifier.value = peopleList;
  }

  _deleteInfo(int index) {
    box.deleteAt(index);
    box.delete("$index");
    print('Info deleted from box!');
  }
}
