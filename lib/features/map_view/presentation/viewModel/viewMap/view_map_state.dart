part of 'view_map_cubit.dart';

@immutable
abstract class ViewMapState {}

class ViewMapInitial extends ViewMapState {}

class ViewMapLoading extends ViewMapState {}

class ViewMapLoaded extends ViewMapState {
  final LatLng location;
  ViewMapLoaded({required this.location});
}

class ViewMapDirection extends ViewMapState {
  final PlaceDetails location;
  final Set<Polyline> polyline;
  final double distance;
  final LatLng start;
  ViewMapDirection({required this.distance,required this.location,required this.polyline,required this.start});
}

class ViewMapPoint extends ViewMapState {
  final PlaceDetails location;
  ViewMapPoint({required this.location});
}

class ViewMapMessage extends ViewMapState {

  final String message;
  ViewMapMessage({required this.message});
}
