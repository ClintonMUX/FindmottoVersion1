
import 'package:firebase_database/firebase_database.dart';
class UserModel {
  String? phone;
  String? name;
  String? id;
  String? email;

  UserModel({
    this.name,
    this.phone,
    this.email,
    this.id,
  }
  );
  

  UserModel.fromSnapshot(DataSnapshot snap){
    phone = (snap.value as dynamic)["Phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
  }
 
}