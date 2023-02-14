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
          builder: (context, box, _) => ListView.separated(
            itemCount: box.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(box.getAt(i).name),
              subtitle: Text(box.getAt(i).country),
            ),
            separatorBuilder: (context, i) => const Divider(),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _addInfo,
              child: Text('Add'),
            ),
            /* ElevatedButton(
              onPressed: _getInfo,
              child: Text('Get'),
            ),
            ElevatedButton(
              onPressed: _updateInfo,
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: _deleteInfo,
              child: Text('Delete'),
            ), */
          ],
        ),
      ),
    );
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
    print(box.values);
    print(box.values.contains(People(name: 'peter', country: 'Nigerai')));

/* 
     box.add(People(
      name: name,
      country: country,
    )); */

    /* List<People> peopleList = [];

    final hivePeople = peopleBox.get('peopleList');

    if (null != hivePeople && hivePeople.isNotEmpty) {
      print('hiveP inside: $hivePeople');
      print('peopleList inside: $peopleList');
      peopleList = hivePeople;
      print('peopleList after: $peopleList');
    }
    print('peopleList outside: $peopleList');
 

     peopleBox.put('peopleList', peopleList);
    for (People person in peopleBox.get('peopleList')) {
      print(person.toString());
    }

    /* peopleListNotifier.value = peopleList; */ */
  }

  _getInfo() {
    final peopleList = <People>[];

    for (People person in box.get('peopleList')) {
      if (!peopleList.contains(person)) {
        peopleList.add(person);
      }
      print(person.toString());
    }
    peopleListNotifier.value = peopleList;
  }

  _updateInfo() {
    final peopleList = <People>[];
    peopleList.add(People(name: 'aku', country: 'India'));
    box.put('peopleList', peopleList);
    peopleListNotifier.value = peopleList;
  }

  _deleteInfo() {
    print('Info deleted from box!');
  }
}
