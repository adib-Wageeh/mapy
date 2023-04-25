part of 'view_places_cubit.dart';

@immutable
abstract class ViewPlacesState {}

class ViewPlacesInitial extends ViewPlacesState {}
class ViewPlacesLoading extends ViewPlacesState {}
class ViewPlacesEmpty extends ViewPlacesState {}

class ViewPlacesLoaded extends ViewPlacesState {

  final List<Prediction> predictions;
  ViewPlacesLoaded({required this.predictions});
}
