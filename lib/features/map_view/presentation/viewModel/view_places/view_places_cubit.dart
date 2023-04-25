import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_webservice/places.dart';
import '../../../../../core/location_helper/location_helper.dart';

part 'view_places_state.dart';

class ViewPlacesCubit extends Cubit<ViewPlacesState> {
  ViewPlacesCubit() : super(ViewPlacesInitial());


  Future<void> searchLocationByName(String text)async{

    if(text.isEmpty){
      emit(ViewPlacesEmpty());
    }else {
      LocationHelper locationHelper = LocationHelper();
      final result = await locationHelper.searchLocation(text);
      emit(ViewPlacesLoaded(predictions: result));
    }

  }


}
