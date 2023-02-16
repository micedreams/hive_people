import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../people.dart';

part 'my_home_page_event.dart';
part 'my_home_page_state.dart';

class MyHomePageBloc extends Bloc<MyHomePageEvent, MyHomePageBlocState> {
  final box = Hive.box('peopleBox');

  MyHomePageBloc() : super(MyHomePageBlocState(box: Hive.box('peopleBox'))) {
    on<AddEntryMyHomePageEvent>((event, emit) {
      final newBox = addPeople(event.box, event.name, event.country);
      emit(MyHomePageBlocState(box: newBox));
    });

    on<UpdateEntryMyHomePageEvent>((event, emit) {
      final newBox =
          updatePeople(event.box, event.index, event.name, event.country);
      emit(MyHomePageBlocState(box: newBox));
    });
    on<DeleteEntryMyHomePageEvent>((event, emit) {
      final newBox = deletePeople(event.box, event.index);
      emit(MyHomePageBlocState(box: newBox));
    });
  }

  addPeople(Box box, String name, String country) {
    final newPerson = People(
      name: name,
      country: country,
    );

    if (!newPerson.existsInList(box.values)) {
      box.add(newPerson);
    }

    return box;
  }

  updatePeople(Box box, int index, String name, String country) {
    final newPerson = People(
      name: name,
      country: country,
    );

    if (!newPerson.existsInList(box.values)) {
      box.putAt(index, newPerson);
    }
    return box;
  }

  deletePeople(Box box, int index) {
    box.deleteAt(index);
    box.delete("$index");
    return box;
  }

  void dispose() {
    Hive.close();
  }
}
