import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mapy/features/map_view/presentation/viewModel/view_places/view_places_cubit.dart';
import 'core/location_helper/location_helper.dart';
import 'features/map_view/presentation/view/map_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/map_view/presentation/viewModel/viewMap/view_map_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void main() {

  EasyLoading.instance
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.deepPurpleAccent
    ..maskColor = Colors.deepPurpleAccent
    ..userInteractions = false;
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjection();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<ViewMapCubit>(create: (context)=>ViewMapCubit()..getCurrentLocation()),
        BlocProvider<ViewPlacesCubit>(create: (context)=>ViewPlacesCubit())
      ]
      ,child: MaterialApp(
  debugShowCheckedModeBanner: false
  ,home: MapSample(),
  builder: EasyLoading.init(),
  )));

}

void dependencyInjection(){

  getIt.registerSingleton<LocationHelper>(LocationHelper());

}
