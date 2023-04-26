import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapy/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/location_helper/location_helper.dart';
import 'package:google_maps_webservice/places.dart';

part 'view_map_state.dart';

class ViewMapCubit extends Cubit<ViewMapState> {
  ViewMapCubit() : super(ViewMapInitial());

  LocationHelper locationHelper = getIt<LocationHelper>();

  Future<void> getCurrentLocation()async{

    emit(ViewMapLoading());
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(ViewMapMessage(message: 'Location services are disabled.'));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(ViewMapMessage(message: 'Location permissions are denied'));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      emit(ViewMapMessage(
          message: 'Location permissions are permanently denied, we cannot request permissions.'));
    }

    final Position position = await Geolocator.getCurrentPosition();

    emit(ViewMapLoaded(location: LatLng(position.latitude, position.longitude)));
  }



  Future<void> getLocationByPlaceId(Prediction prediction)async{

    emit(ViewMapLoading());
    final location = await locationHelper.getPlaceById(prediction);
    emit(ViewMapPoint(location: location));
  }




  Future<void> viewDirections(PlaceDetails end,BuildContext context)async{
    emit(ViewMapLoading());
    final Position start = await Geolocator.getCurrentPosition();

    final endLatlng = LatLng(end.geometry!.location.lat,end.geometry!.location.lng);
    if(Geolocator.distanceBetween(start.latitude, start.longitude, end.geometry!.location.lat, end.geometry!.location.lat)<30){
      emit(ViewMapMessage(message: "please select another point"));
    }else {
      final result = await locationHelper.drawDirections(
          LatLng(start.latitude, start.longitude), endLatlng);
      double distance = locationHelper.getDistance(LatLng(start.latitude,start.longitude), endLatlng);
      emit(ViewMapDirection(start: LatLng(start.latitude, start.longitude),polyline: result,location:  end,distance: distance));
    }

  }


  Future<void> saveDirection(BuildContext context,PlaceDetails end)async{
    emit(ViewMapLoading());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getStringList(end.name) == null){
      await prefs.setStringList(end.name, [end.geometry!.location.lat.toString(),end.geometry!.location.lng.toString()]);
      emit(ViewMapMessage(message: "Direction saved successfully"));
    }else{
      emit(ViewMapMessage(message: "Direction already saved !!"));
    }

  }

}
