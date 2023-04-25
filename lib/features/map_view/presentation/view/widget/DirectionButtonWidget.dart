import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../viewModel/viewMap/view_map_cubit.dart';

class DirectionButtonWidget extends StatelessWidget {

  final LatLng end;
  const DirectionButtonWidget({required this.end,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        left: 20
        ,child: FloatingActionButton(onPressed: () async{

      EasyLoading.instance
        ..backgroundColor = Colors.white
        ..indicatorColor = Colors.black
        ..maskColor = Colors.black
        ..userInteractions = false;
      EasyLoading.show(status: 'loading...');
      await BlocProvider.of<ViewMapCubit>(context).viewDirections(end,context);
      EasyLoading.dismiss();
    },
      backgroundColor: Colors.deepPurpleAccent,
      child: const Icon(Icons.directions),
    ));
  }
}