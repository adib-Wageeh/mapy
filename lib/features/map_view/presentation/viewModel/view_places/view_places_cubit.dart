import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_webservice/places.dart';
import '../../../../../core/location_helper/location_helper.dart';

part 'view_places_state.dart';

class ViewPlacesCubit extends Cubit<ViewPlacesState> {
  ViewPlacesCubit() : super(ViewPlacesInitial());

  int again =1;

  Future<void> searchLocationByName(String text)async{
    again =1;
    LocationHelper locationHelper = LocationHelper();
      final result = await locationHelper.searchLocation(text);

      if(result.isEmpty){
        again =0;
        emit(ViewPlacesEmpty());
      }else if(again !=0){
        emit(ViewPlacesLoaded(predictions: result));
      }
  }

}
