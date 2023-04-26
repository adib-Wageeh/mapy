import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapy/main.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/location_helper/location_helper.dart';
import 'package:google_maps_webservice/places.dart';

part 'view_map_state.dart';

class ViewMapCubit extends Cubit<ViewMapState> {
  ViewMapCubit() : super(ViewMapInitial());

  LocationHelper locationHelper = getIt<LocationHelper>();

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

    final location = await locationHelper.getPlaceById(prediction);


    emit(ViewMapPoint(location: location));
  }




  Future<void> viewDirections(PlaceDetails end,BuildContext context)async{

    final Position start = await Geolocator.getCurrentPosition();

    final endLatlng = LatLng(end.geometry!.location.lat,end.geometry!.location.lng);
    if(Geolocator.distanceBetween(start.latitude, start.longitude, end.geometry!.location.lat, end.geometry!.location.lat)<30){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("please select another point"), ));
    }else {
      final result = await locationHelper.drawDirections(
          LatLng(start.latitude, start.longitude), endLatlng);
      double distance = locationHelper.getDistance(LatLng(start.latitude,start.longitude), endLatlng);
      emit(ViewMapDirection(start: LatLng(start.latitude, start.longitude),polyline: result,location:  end,distance: distance));
    }

  }


}
