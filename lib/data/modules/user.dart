import 'package:teach/data/consts/sql_const.dart';

class User {
  // atributes
  var id, name;
  // methods
  // constarctors
  User({required this.id, required this.name});
  // to json method
  toJson() {
    return {columnUserId: id, columnUserName: name};
  }

  toFirebaseJson() {
    return {columnUserName: name};
  }

  // from json method
  User.fromJson(json) {
    id = json[columnUserId];
    name = json[columnUserName];
  }
}
