import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';

import '../../features/map_view/model/polyline_response.dart';

const GOOGLE_API_KEY = "";

class LocationHelper{

  List<Prediction> predictions = [];
  Future<List<Prediction>> searchLocation(String text)async{

    http.Response response = await _getLocationData(text);

    var data = jsonDecode(response.body.toString());
    if(data['status'] == "OK"){
      data['predictions'].forEach((prediction){
        return predictions.add(Prediction.fromJson(prediction));
      });
    }else{


    }
  return predictions;
  }

  Future<PlaceDetails> getPlaceById(Prediction prediction)async{

    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: GOOGLE_API_KEY,
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(prediction.placeId!);

    return detail.result;
  }



  Future<http.Response> _getLocationData(String text)async{

    http.Response response;

    response = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&types=geocode&language=ar&sensor=true&key=$GOOGLE_API_KEY&components=country:eg"),
    headers: {"Content-Type":"application/json"}
    );
    return response;
  }

  Future<Set<Polyline>> drawDirections(LatLng origin,LatLng destination)async{

    Set<Polyline> polyLines = {};
    Response response = await http.post(Uri.parse("https://maps.googleapis.com/maps/api/directions/json?key=$GOOGLE_API_KEY&units=metric&origin=${origin.latitude.toString()},${origin.longitude.toString()}&destination=${destination.latitude.toString()},${destination.longitude.toString()}"));

    PolylineResponse polylineResponse = PolylineResponse.fromJson(jsonDecode(response.body));

    for (int i = 0; i < polylineResponse.routes![0].legs![0].steps!.length; i++) {
      polyLines.add(Polyline(polylineId: PolylineId(polylineResponse.routes![0].legs![0].steps![i].polyline!.points!), points: [
        LatLng(
            polylineResponse.routes![0].legs![0].steps![i].startLocation!.lat!, polylineResponse.routes![0].legs![0].steps![i].startLocation!.lng!),
        LatLng(polylineResponse.routes![0].legs![0].steps![i].endLocation!.lat!, polylineResponse.routes![0].legs![0].steps![i].endLocation!.lng!),
      ],width: 3,color: Colors.deepPurpleAccent));
    }
    return polyLines;
  }

  double getDistance(LatLng start,LatLng end){

    double totalDistance = 0;

      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((end.latitude - start.latitude) * p)/2 +
          c(start.latitude * p) * c(end.latitude * p) *
              (1 - c((end.longitude - start.longitude) * p))/2;
    totalDistance = 12742 * asin(sqrt(a));
      return totalDistance;

  }

}