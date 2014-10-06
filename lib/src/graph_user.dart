part of facebook;

class GraphUser extends GraphObject {

  String get id;
  set id(String id);

  String get name;
  set name(String name);

  String get middleName;
  set middleName(String middleName);

  String get lastName;
  set lastName(String lastName);

  String get link;
  set link(String link);

  String get userName;
  set userName(String userName);

  DateTime get birthday;
  set birthday(DateTime birthday);

  GraphPlace get location;
  set location(GraphPlace location);
}