import 'package:findmotto/models/directions.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;

 // List<String> historyTripsKeysList = [];

 // List<TripsHistoryModel> allTripsHistoryInfromationList = [];

 void updatePickUpLocationAddress(Directions userPickUpAddress){
  userPickUpLocation = userPickUpAddress;
  notifyListeners();
 }

void updateDropOffLocationAddress(Directions DropOffAddresss){
  userDropOffLocation = DropOffAddresss;

  notifyListeners(); 
}
}