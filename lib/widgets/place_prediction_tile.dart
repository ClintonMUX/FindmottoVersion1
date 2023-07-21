import 'package:findmotto/Assistants/request_assistant.dart';
import 'package:findmotto/global/global.dart';
import 'package:findmotto/global/map_key.dart';
import 'package:findmotto/models/directions.dart';
import 'package:flutter/material.dart';
import 'package:findmotto/models/predicted_places.dart';
import 'package:findmotto/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';

class PlacesPredictionTileDesign extends StatefulWidget {


  final PredictedPlaces? predictedPlaces;

  PlacesPredictionTileDesign({this.predictedPlaces});



  @override
  State<PlacesPredictionTileDesign> createState() => _PlacesPredictionTileDesignState();
}

class _PlacesPredictionTileDesignState extends State<PlacesPredictionTileDesign> {

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgessDialog(
           message: "Setting up Drop-off. Pleasw wait..",
        )
    );
    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapkey";

    var reponseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if(reponseApi == "Error Occurred. Failed. No Response."){
      return;
    }
    if(reponseApi['status'] == "OK"){
      Directions directions = Directions();
      directions.locationName = reponseApi["result"]["name"];
      directions.locationid = placeId;
      directions.locationLatitude = reponseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = reponseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.pop(context, "obtainDropOff");
    }
  }
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id!, context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // Set a different color for the background
        onPrimary: darkTheme ? Colors.amber.shade400 : Colors.blue, // Set text and icon color
        elevation: 0, // Remove button elevation if not needed
        padding: EdgeInsets.all(8.0), // Adjust padding as needed
      ),
      child: Row(
        children: [
          Icon(
            Icons.add_location,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.predictedPlaces!.main_text!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.predictedPlaces!.secondary_text!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
