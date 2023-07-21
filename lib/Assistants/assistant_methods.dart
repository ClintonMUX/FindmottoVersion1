
import 'package:findmotto/global/map_key.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:findmotto/global/global.dart';
import 'package:findmotto/models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:findmotto/Assistants/request_assistant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmotto/models/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../models/direction_details_info.dart';



class AssistantMethods {

  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
     .ref()
     .child("Users")
     .child(currentUser!.uid);
     
     userRef.once().then((snap){
      if(snap.snapshot.value!= null){
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
     });
     
       }

  static Future<String> searchAddressForGoographicCordinates(Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    String humanReadAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    print("Request Response: $requestResponse");

    if (requestResponse != "Error Occurred. Failed. No Response.") {
      var results = requestResponse["results"];
      if (results != null && results.isNotEmpty) {
        humanReadAddress = results[0]['formatted_address'];

        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = position.latitude;
        userPickUpAddress.locationLongitude = position.longitude;
        userPickUpAddress.locationName = humanReadAddress;

        Provider.of<AppInfo>(context, listen: false)
            .updatePickUpLocationAddress(userPickUpAddress);
      }
    }

    print("Human Read Address: $humanReadAddress");
    return humanReadAddress;
  }

     static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async{

      String urlOriginToDestinationDirectionDetails ="https://maps.googleapis.com/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${originPosition.longitude}&key=$mapkey";
      var reponseDirectionsAPI = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);
      //if(reponseDirectionsAPI == "Error Occurred. Failed. No Response."){
       // return null;
      //}

      DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
      directionDetailsInfo.e_points =reponseDirectionsAPI["routes"][0]["overview_polyline"]["points"];

      directionDetailsInfo.distance_text =reponseDirectionsAPI["routes"][0]["legs"]["distance"]["text"];
      directionDetailsInfo.distance_value =reponseDirectionsAPI["routes"][0]["legs"]["distance"]["value"];
      directionDetailsInfo.duration_text =reponseDirectionsAPI["routes"][0]["legs"]["duration"]["text"];
      directionDetailsInfo.duraction_value =reponseDirectionsAPI["routes"][0]["legs"]["duration"]["value"];

      return directionDetailsInfo;

     }
}

