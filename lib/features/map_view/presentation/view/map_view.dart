import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapy/features/map_view/presentation/view/widget/DirectionButtonWidget.dart';
import 'package:mapy/features/map_view/presentation/view/widget/DistanceWidget.dart';
import 'package:mapy/features/map_view/presentation/view/widget/FloatingActionWidget.dart';
import 'package:mapy/features/map_view/presentation/view/widget/SearchContainer.dart';
import 'package:mapy/features/map_view/presentation/view/widget/SearchResultView.dart';
import 'package:mapy/features/map_view/presentation/view/widget/ShowMapWidget.dart';
import 'package:mapy/features/map_view/presentation/viewModel/viewMap/view_map_cubit.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with SingleTickerProviderStateMixin{
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  TextEditingController textEditingController = TextEditingController();
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }
  Future<void> animateTo(double lat, double lng) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 16.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
           animateTo(state.location.latitude,state.location.longitude);
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
                  DirectionButtonWidget(end: LatLng(state.location.latitude,state.location.longitude),)
                ],
              );
            }
            else if(state is ViewMapPoint){
              return Stack(
                children: [
                  ShowMapWidget(controller: _controller,latLng: state.location),
                  FloatingActionWidget(animationController: _animationController, animation: _animation),
                  const BackButton(),
                ],
              );
            }else if(state is ViewMapDirection){
              return Stack(
                children: [
                  ShowMapWidget(controller: _controller,latLng: state.location,polylines: state.polyline),
                  FloatingActionWidget(animationController: _animationController, animation: _animation),
                  const BackButton(),
                  DistanceWidget(distance: state.distance,),
                  DirectionButtonWidget(end: LatLng(state.location.latitude,state.location.longitude),),
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

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
    top: 30,
    left: 20
    ,child: IconButton(onPressed: ()async{
      EasyLoading.instance
        ..backgroundColor = Colors.white
        ..indicatorColor = Colors.black
        ..maskColor = Colors.black
        ..userInteractions = false;
      EasyLoading.show(status: 'loading...');

       await BlocProvider.of<ViewMapCubit>(context).getCurrentLocation();
      EasyLoading.dismiss();

      }, icon: const Icon(Icons.arrow_back_ios_new_sharp)),
    );
  }
}


  


