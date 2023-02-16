part of 'my_home_page_bloc.dart';

@immutable
abstract class MyHomePageEvent {}


class AddEntryMyHomePageEvent extends MyHomePageEvent {
  final Box box;
  final String name;
  final String country;

  AddEntryMyHomePageEvent(this.box, this.name, this.country);


}

class UpdateEntryMyHomePageEvent extends MyHomePageEvent {
  final Box box;
  final int index;
  final String name;
  final String country;

  UpdateEntryMyHomePageEvent(this.box, this.index, this.name, this.country);


}

class DeleteEntryMyHomePageEvent extends MyHomePageEvent {
  final Box box;
  final int index;

  DeleteEntryMyHomePageEvent(this.box, this.index);

 
}
