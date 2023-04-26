import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapy/features/map_view/presentation/view/widget/BackButtonWidget.dart';
import 'package:mapy/features/map_view/presentation/view/widget/CustomDirectionsButton.dart';
import 'package:mapy/features/map_view/presentation/view/widget/FloatingSaveWidget.dart';
import 'package:mapy/features/map_view/presentation/view/widget/FromToContainer.dart';
import 'package:mapy/features/map_view/presentation/view/widget/SearchContainer.dart';
import 'package:mapy/features/map_view/presentation/view/widget/SearchResultView.dart';
import 'package:mapy/features/map_view/presentation/view/widget/ShowMapWidget.dart';
import 'package:mapy/features/map_view/presentation/viewModel/viewMap/view_map_cubit.dart';
import 'package:google_maps_webservice/places.dart';

class MapSample extends StatelessWidget {

  MapSample({Key? key}) : super(key: key);

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

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
           EasyLoading.dismiss();
           animateTo(state.location.latitude,state.location.longitude);
         }
         if(state is ViewMapDirection){
           EasyLoading.dismiss();
           animateTo(state.start.latitude,state.start.longitude);
         }
         if(state is ViewMapPoint){
           EasyLoading.dismiss();
           animateTo(state.location.geometry!.location.lat,state.location.geometry!.location.lng);
         }
         if(state is ViewMapLoading){
           EasyLoading.show();
         }
         if(state is ViewMapMessage){
           EasyLoading.dismiss();
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
         }
        }
        ,buildWhen: (previousState, currentState){
          if(currentState is ViewMapLoading || currentState is ViewMapMessage){
            return false;
          }
          return true;
        },
          builder: (context, state) {
            if (state is ViewMapLoaded) {
              return Stack(
                children: [
                  ShowMapWidget(controller: _controller,latLng:Location(lng: state.location.longitude,lat: state.location.latitude)),
                  SearchContainer(textEditingController: TextEditingController()),
                  SearchResultView(textEditingController: TextEditingController()),
                ],
              );
            }
            else if(state is ViewMapPoint){
              return Stack(
                children: [
                  ShowMapWidget(controller: _controller,latLng: state.location.geometry!.location),
                  const BackButtonWidget(),
                  CustomDirectionsButton(end: state.location,),
                ],
              );
            }else if(state is ViewMapDirection){
              return Stack(
                children: [
                  ShowMapWidget(start: state.start,controller: _controller,latLng: Location(lng: state.location.geometry!.location.lng,lat: state.location.geometry!.location.lat),polylines: state.polyline),
                  FloatingSaveWidget(text: "Save Directions",onTap: ()async{
                    await BlocProvider.of<ViewMapCubit>(context).saveDirection(context, state.location);
                  }),
                  const BackButtonWidget(),
                  FromToContainer(start: state.start,onTab: (Location place){
                    animateTo(place.lat,place.lng);
                  },end: state.location,distance: state.distance),
                ],
              );
            }
            return Container();
          },
        ),
      );
    }}