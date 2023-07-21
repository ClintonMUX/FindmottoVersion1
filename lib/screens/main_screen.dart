import 'package:findmotto/Assistants/assistant_methods.dart';
import 'package:findmotto/global/global.dart';
import 'package:findmotto/infoHandler/app_info.dart';
import 'package:findmotto/screens/search_places_screen.dart';
import 'package:findmotto/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:findmotto/global/map_key.dart';

//import 'package:geolocator/geolocator.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:provider/provider.dart';
import 'package:findmotto/themeProvider/themeProvider.dart';




import '../models/directions.dart';


class Mainscreen extends StatefulWidget {
  const Mainscreen({Key? key}) : super(key: key);


  @override

  State<Mainscreen> createState() => _MainscreenState();
}


class _MainscreenState extends State<Mainscreen> {

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;


   final Completer<GoogleMapController> _controllerGoogleMap = Completer();

     GoogleMapController? newGoogleMapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
double searchLocationContainerHeight = 220;

double waitingResponsefromDriverContainerHeight = 0;

double assignDriverInfoContainerHeight = 0;

Position? userCurrentPosition;
var geolocation = Geolocator();

LocationPermission? _locationPermision;
double bottomPaddingofMap = 0;

List<LatLng> pLineCordinatesList = [];

Set<Polyline> polylineSet = {};

Set<Marker> markerSet = {};

Set<Circle> circleSet = {};

String userName = "";
String userEmail ="";

bool openNavigatinDrawer = true;

bool activeNearbyDriverKeysLoaded = false;

BitmapDescriptor? activeNearbyIcon;

/*
locateUserPosition() async{

  Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  userCurrentPosition = cPosition;

  LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
  CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

  newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  String humanReadAddress = await AssistantMethods.searchAddressForGoographicCordinates(userCurrentPosition!, context);
   print("This is our address = " + humanReadAddress);

  userName = userModelCurrentInfo!.name!;
  userEmail = userModelCurrentInfo!.email!;
  ; */


locateUserPosition() async {
  Position? cPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  if (cPosition != null) {
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition, zoom: 15);

    newGoogleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadAddress = await AssistantMethods
        .searchAddressForGoographicCordinates(userCurrentPosition!, context);
    print("This is our address = " + humanReadAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;
    //end

    // initializeGeoFireListener();
//
    //AsistantMethods.readTripsKeyForOnlineUser(context);

  }
}
  Future<void> drawPolyLineFromOriginToDesignToDestination(bool darkTheme) async {
    var originPosition = Provider
        .of<AppInfo>(context, listen: false)
        .userPickUpLocation;
    var destinationPosition = Provider
        .of<AppInfo>(context, listen: false)
        .userDropOffLocation;
    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);

    var destinationLatLing = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext) => ProgessDialog(message: "Please wait...",),
    );

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLing,);
    setState(() {
        tripDirectionDetailsInfo = directionDetailsInfo;
    });

   Navigator.pop(context) ;

   PolylinePoints pPoints = PolylinePoints();

   List<PointLatLng> decodePolyLiePointsResultsList = pPoints.decodePolyline(directionDetailsInfo.e_points!);

   pLineCordinatesList.clear();

   if(decodePolyLiePointsResultsList.isNotEmpty){
     decodePolyLiePointsResultsList.forEach((PointLatLng pointLatLng) {
         pLineCordinatesList.add(LatLng(pointLatLng.latitude,pointLatLng.longitude ));
     });

         polylineSet.clear();

     setState(() {
       Polyline polyline = Polyline(
           color:  darkTheme? Colors.amber : Colors.blue,
         polylineId: PolylineId("PolylineID"),
         jointType: JointType.round,
         points: pLineCordinatesList,
         startCap: Cap.roundCap,
         endCap: Cap.roundCap,
         geodesic: true,
         width: 5,

       );

       polylineSet.add(polyline);
     });
     LatLngBounds boundsLatLng;
     if(originLatLng.latitude > destinationLatLing.latitude && originLatLng.longitude > destinationLatLing.longitude){
       boundsLatLng = LatLngBounds(southwest: destinationLatLing, northeast: originLatLng);
     } else if(originLatLng.longitude > destinationLatLing.longitude){
       boundsLatLng = LatLngBounds(
           southwest: LatLng(originLatLng.latitude, destinationLatLing.longitude),
           northeast: LatLng(destinationLatLing.latitude, originLatLng.longitude),
       );
     }
     else if(originLatLng.latitude > destinationLatLing.latitude){
       boundsLatLng = LatLngBounds
         (
         southwest: LatLng(destinationLatLing.latitude, originLatLng.longitude),
         northeast: LatLng(originLatLng.latitude, destinationLatLing.longitude),
       );
     }
     else {
        boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLing);

     }

     newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

   }
}



getAddressFromLatling() async {
  try{
    GeoData data = await Geocoder2.getDataFromCoordinates(
      latitude: pickLocation!.latitude,
      longitude: pickLocation!.longitude,
      googleMapApiKey: mapkey,
    );
     setState(() {

       Directions userPickUpAddress = Directions();

       userPickUpAddress.locationLatitude = pickLocation!.latitude;
       userPickUpAddress.locationLongitude = pickLocation!.longitude;
       userPickUpAddress.locationName = data.address;

       Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
       //_address = data.address;

     });
  } catch (e) {
    print(e);
  }

}

 checkIfLocationPermissionAllowed() async{
 _locationPermision = await Geolocator.requestPermission();

 if(_locationPermision == LocationPermission.denied){
   _locationPermision = await Geolocator.requestPermission();
 }
 }

  @override
void initState() {
    // TODO: implement initState
    super.initState();

    checkIfLocationPermissionAllowed();
  }
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(

onTap: () {

     FocusScope.of(context).unfocus();

},
 child: Scaffold(
  body: Stack(
    children: [
      GoogleMap(
        mapType: MapType.normal,
         myLocationEnabled: true,
         zoomGesturesEnabled: true,
         zoomControlsEnabled: true,
        initialCameraPosition: _kGooglePlex,
        polylines: polylineSet,
        markers: markerSet,
        circles: circleSet,

//edit
          onMapCreated: (GoogleMapController controller) {
  _controllerGoogleMap.complete(controller);
  newGoogleMapController = controller;

  setState(() {});
  locateUserPosition();
},



//edit
        onCameraMove: (CameraPosition? position){
          if(position != null && pickLocation != position.target){
            setState(() {
              pickLocation = position.target;
            });
          }
        },
       onCameraIdle: () {
        getAddressFromLatling();
       },
        ),
        Align(
    alignment: Alignment.center,
    child: Padding (
       padding: const EdgeInsets.only(bottom: 35.0),
       child: Image.asset('images/mapi.png', height: 45, width: 45),
     ) ,
    ),

    // UIfor searching Location
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: darkTheme? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10),


                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:  darkTheme ? Colors.grey.shade900 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),

                      ),
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row (
                                    children: [
                                 Icon(Icons.location_on_outlined, color: darkTheme ? Colors.amber.shade400 : Colors.blue ,),
                                    SizedBox(width: 10,),
                                      Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Text("From",
                                              style: TextStyle(
                                          color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      )

                                          ),
                                         /* Text(Provider.of<AppInfo>(context).userPickUpLocation != null
                                              ?  (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24) + "..."
                                              : "Not Getting Address",
                                            style: TextStyle(color: Colors.grey, fontSize: 14),

                                          )*/

                                          Text(Provider.of<AppInfo>(context).userPickUpLocation != null
                                              ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).length > 24
                                              ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24) + "..."
                                              : (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!)
                                              : "Not Getting Address",
                                            style: TextStyle(color: Colors.grey, fontSize: 14),
                                          )



                                        ],
                                      )
                                    ]
        )
                              ),

                              SizedBox(height: 5,),

                              Divider(
                                height: 1,
                                thickness: 2,
                                color: darkTheme ? Colors.amber.shade400 : Colors.blue,

                              ),

                              SizedBox(height: 5,),

                              Padding(
                                  padding: EdgeInsets.all(5),
                                 child: GestureDetector(
                                   onTap: () async {
                                     // go to search places screen
                                     var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen()));

                                     if(responseFromSearchScreen == "obtainedDropoff"){

                                       setState(() {
                                         openNavigatinDrawer = false;
                                       });
                                     }
                                     await drawPolyLineFromOriginToDesignToDestination(darkTheme);

                                   },
                                   child: Row (
                                 children: [
                                 Icon(Icons.location_on_outlined, color: darkTheme ? Colors.amber.shade400 : Colors.blue ,),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Text("To",
                                          style: TextStyle(
                                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )

                                      ),
                                      Text(Provider.of<AppInfo>(context).userDropOffLocation!= null
                                          ?  Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                          : "Where to?",
                                        style: TextStyle(color: Colors.grey, fontSize: 14),

                                      )


                                    ],
                                  )
                                  ]
                              ) ,
                                 ),
                              ),

                            ],
                          )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    /*Positioned(

       top: 40,
       right: 20,
       left: 20,

       child: Container (
        decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.white
         ),
         padding: EdgeInsets.all(20),
      child: Text(
        Provider.of<AppInfo>(context).userPickUpLocation != null
            ?  (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24) + "..."
            : "Not Getting Address",
      overflow: TextOverflow.visible, softWrap: true,)
       ),

    )*/
    ],
  ),

 ),
    );
  }
}