import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapy/features/map_view/presentation/view/widget/BackButtonWidget.dart';
import 'package:mapy/features/map_view/presentation/view/widget/CustomDirectionsButton.dart';
import 'package:mapy/features/map_view/presentation/view/widget/DistanceWidget.dart';
import 'package:mapy/features/map_view/presentation/view/widget/FloatingSaveWidget.dart';
import 'package:mapy/features/map_view/presentation/view/widget/SearchContainer.dart';
import 'package:mapy/features/map_view/presentation/view/widget/SearchResultView.dart';
import 'package:mapy/features/map_view/presentation/view/widget/ShowMapWidget.dart';
import 'package:mapy/features/map_view/presentation/viewModel/viewMap/view_map_cubit.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample>{
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  TextEditingController textEditingController = TextEditingController();


  Future<void> animateTo(double lat, double lng) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 16.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }


    @override
    Widget build(BuildContext context) {

      return Scaffold(
        body: BlocConsumer<ViewMapCubit, ViewMapState>(
        listener: (context,state){
         if(state is ViewMapLoaded){
           animateTo(state.location.latitude,state.location.longitude);
         }
         if(state is ViewMapDirection){
           animateTo(state.start.latitude,state.start.longitude);
         }
         if(state is ViewMapPoint){
           animateTo(state.location.latitude,state.location.longitude);
         }
        }
        ,builder: (context, state) {
            if (state is ViewMapLoaded) {
              return Stack(
                children: [
                  ShowMapWidget(controller: _controller,latLng: state.location),
                  SearchContainer(textEditingController: textEditingController),
                  SearchResultView(textEditingController: textEditingController),
                ],
              );
            }
            else if(state is ViewMapPoint){
              return Stack(
                children: [
                  ShowMapWidget(controller: _controller,latLng: state.location),
                  FloatingSaveWidget(text: "Save Location",onTap: (){}),
                  const BackButtonWidget(),
                  CustomDirectionsButton(end: LatLng(state.location.latitude,state.location.longitude),),
                ],
              );
            }else if(state is ViewMapDirection){
              return Stack(
                children: [
                  ShowMapWidget(start: state.start,controller: _controller,latLng: state.location,polylines: state.polyline),
                  FloatingSaveWidget(text: "Save Directions",onTap: (){}),
                  const BackButtonWidget(),
                  DistanceWidget(distance: state.distance,),
                ],
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    }
  }