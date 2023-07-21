import 'package:findmotto/models/direction_details_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmotto/models/user_model.dart';


final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;
String userDropOffAddress = "";

DirectionDetailsInfo? tripDirectionDetailsInfo;