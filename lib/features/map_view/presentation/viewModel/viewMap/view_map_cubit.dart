import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/location_helper/location_helper.dart';
import 'package:google_maps_webservice/places.dart';

part 'view_map_state.dart';

class ViewMapCubit extends Cubit<ViewMapState> {
  ViewMapCubit() : super(ViewMapInitial());

  Future<void> getCurrentLocation()async{

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(ViewMapError(error: 'Location services are disabled.'));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(ViewMapError(error: 'Location permissions are denied'));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      emit(ViewMapError(
          error: 'Location permissions are permanently denied, we cannot request permissions.'));
    }

    final Position position = await Geolocator.getCurrentPosition();

    emit(ViewMapLoaded(location: LatLng(position.latitude, position.longitude)));
  }

  Future<void> getLocationByPlaceId(Prediction prediction)async{

    LocationHelper locationHelper = LocationHelper();
    final location = await locationHelper.getPlaceById(prediction);
    emit(ViewMapPoint(location: LatLng(location.lat, location.lng)));
  }

  Future<void> viewDirections(LatLng end,BuildContext context)async{

    LocationHelper locationHelper = LocationHelper();
    final Position start = await Geolocator.getCurrentPosition();


    if(Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude)<30){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("please select another point"), ));
    }else {
      final result = await locationHelper.drawDirections(
          LatLng(start.latitude, start.longitude), end);
      double distance = locationHelper.getDistance(LatLng(start.latitude,start.longitude), end);
      emit(ViewMapDirection(polyline: result,location:  end,distance: distance));
    }

  }


}
