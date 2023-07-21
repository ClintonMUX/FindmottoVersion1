/*import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {

  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpRespose = await http.get(Uri.parse(url));

    try {
      if(httpResponse.statusCode == 200) // succesful
      {
        String responseData = httpResponse.body; // json
        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      } else {
        return "Error Occured, Failed No Response,";
      }
    } catch(exp){
       return "Error Occured, Failed No Response,";
      
    }
  }
}*/

import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try {
      if (httpResponse.statusCode == 200)  //success
      {
        String responseData = httpResponse.body;
        var decodedResponseData = jsonDecode(responseData);
        return decodedResponseData;
      } else {
        return "Error Occurred. Failed. No Response.";
      }
    } catch (exp) {
      return "Error Occurred. Failed. No Response.";
    }
  }
}
