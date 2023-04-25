import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mapy/features/map_view/presentation/viewModel/view_places/view_places_cubit.dart';
import 'features/map_view/presentation/view/map_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/map_view/presentation/viewModel/viewMap/view_map_cubit.dart';

void main() {


  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<ViewMapCubit>(create: (context)=>ViewMapCubit()..getCurrentLocation()),
        BlocProvider<ViewPlacesCubit>(create: (context)=>ViewPlacesCubit())
      ]
      ,child: MaterialApp(home: const MapSample(),
  builder: EasyLoading.init(),
  )));
}
