import 'package:teach/data/consts/sql_const.dart';

class UserPlus {
  var id, name, phone, email, password, isManager, isMainManager;
  // constructor
  UserPlus(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.password,
      required this.isManager,
      required this.isMainManager});

  // tojoson method
  toJson() {
    return {
      userId: id,
      userName: name,
      userPhone: phone,
      userEmail: email,
      userPassword: password,
      userIsManager: isManager ? "true" : "false",
      userIsMainManager: isMainManager ? "true" : "false",
    };
  }

  toFirebaseJson() {
    return {
      userName: name,
      userPhone: phone,
      userEmail: email,
      userPassword: password,
      userIsManager: isManager,
      userIsMainManager: isMainManager,
    };
  }

  // fromJson method
  UserPlus.fromJson(json) {
    id = json[userId];
    name = json[userName];
    phone = json[userPhone];
    email = json[userEmail];
    password = json[userPassword];
    isManager = json[userIsManager];
    isMainManager = json[userIsMainManager];
  }
}
