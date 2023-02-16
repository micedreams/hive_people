import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bloc/bloc/my_home_page_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController();
  final countryController = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MyHomePageBloc, MyHomePageBlocState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: (state.box.isEmpty)
                  ? const Center(child: Text('Add a contact'))
                  : ListView.separated(
                      itemCount: state.box.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) => ListTile(
                        onLongPress: () =>
                            updateDetails(context, state.box, index),
                        onTap: () => showDetails(context, state.box, index),
                        title: Text(state.box.getAt(index).name),
                        subtitle: Text(state.box.getAt(index).country),
                        trailing: IconButton(
                          onPressed: () {
                            return BlocProvider.of<MyHomePageBloc>(context).add(
                                DeleteEntryMyHomePageEvent(state.box, index));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => addDetails(state.box),
                child: const Icon(Icons.add),
              ),
            ),
          );
        },
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

  void addDetails(Box box) async => showDialog(
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
                final name = nameController.text.trim();
                final country = countryController.text.trim();
                nameController.clear();
                countryController.clear();
                Navigator.pop(context);
                return BlocProvider.of<MyHomePageBloc>(context)
                    .add(AddEntryMyHomePageEvent(
                  box,
                  name,
                  country,
                ));
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
              return BlocProvider.of<MyHomePageBloc>(context)
                  .add(UpdateEntryMyHomePageEvent(
                box,
                index,
                nameController.text.trim(),
                countryController.text.trim(),
              ));

              nameController.clear();
              countryController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
