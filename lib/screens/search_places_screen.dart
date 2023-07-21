import 'package:findmotto/Assistants/request_assistant.dart';
import 'package:findmotto/global/map_key.dart';
import 'package:findmotto/widgets/place_prediction_tile.dart';
import 'package:flutter/material.dart';

import '../models/predicted_places.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {

  List<PredictedPlaces> placesPredictedList =[];

   findPlacesAutoCompleteSearch(String inputText) async{
           if(inputText.length > 1) {
            String urlAuthCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapkey&components=country:CM";

            var reponseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAuthCompleteSearch);
            if(reponseAutoCompleteSearch == "Error Occurred. Failed. No Response."){
              return;
            }
            if(reponseAutoCompleteSearch["status"] == "OK"){
              var placePredictions = reponseAutoCompleteSearch["predictions"];

              var placePredictionsList  = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

              setState(() {
                placesPredictedList = placePredictionsList;
              });
            }


           }


   }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();

        },
      child: Scaffold(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: darkTheme? Colors.amber.shade400 : Colors.blue,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: darkTheme ? Colors.black : Colors.white),

          ),
          title: Text(
            "Search & Set dropOff Location",
            style: TextStyle(color:  darkTheme ? Colors.black : Colors.white),
          ),
          elevation:  0.0,
        ),
          body: Column(
            children: [
              Container (
                  decoration: BoxDecoration(
                      color: darkTheme ? Colors.black : Colors.blue,
                      boxShadow: [
                        BoxShadow(

                      color: Colors.white54,
                      blurRadius: 8,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      )
                                )
                               ],
                  ),
                      child: Padding(
                padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [

                                Icon(
                                    Icons.adjust_sharp,
                                  color: darkTheme ? Colors.black : Colors.white,
                                ),

                                SizedBox(height: 18.0,),

                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8),

                                      child: TextField(
                                        onChanged: (value){
                                          findPlacesAutoCompleteSearch(value);
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Search Location Here ..",
                                              fillColor: darkTheme ? Colors.black : Colors.white54,
                                          filled: true,

                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                            left:  11,
                                            top: 8,
                                            bottom: 8,
                                          )
                                        ),
                                      ),
                                    ))

                              ],
                            )
                          ],
                        ),

      )
              ),
                //display place predictions results

                (placesPredictedList.length > 0)
              ? Expanded(
                    child: ListView.separated(
                      itemCount: placesPredictedList.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder:(context, index){
                        return PlacesPredictionTileDesign(
                          predictedPlaces: placesPredictedList[index],
                        );
                      },

                        separatorBuilder: (BuildContext context, int index){
                         return Divider(
                           height: 0,
                           color: darkTheme? Colors.amber.shade400 : Colors.blue,
                           thickness: 0,

                         );
                        },

                    )
                ) : Container(),


            ],
          ),

      ),

    );
  }
}
