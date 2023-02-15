import 'package:hive/hive.dart';
part 'people.g.dart';

@HiveType(typeId: 1)
class People {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String country;

  People({
    required this.name,
    required this.country,
  });

  @override
  String toString() {
    return "People(name:$name, country: $country)";
  }

  bool equal(People other) {
    if (name == other.name && country == other.country) {
      return true;
    }
    return false;
  }

  bool existsInList(list) {
    for (var value in list) {
      if (value.equal(this)) {
        return true;
      }
    }
    return false;
  }
}
