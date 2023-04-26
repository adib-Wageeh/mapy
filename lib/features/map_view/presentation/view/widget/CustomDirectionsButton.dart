import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_webservice/places.dart';
import '../../viewModel/viewMap/view_map_cubit.dart';

class CustomDirectionsButton extends StatelessWidget {

  final PlaceDetails end;
  const CustomDirectionsButton({required this.end,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        left: 20
        ,child: FloatingActionButton(onPressed: () async{

      EasyLoading.show(status: 'loading...');
      await BlocProvider.of<ViewMapCubit>(context).viewDirections(end,context);
      EasyLoading.dismiss();
    },
      backgroundColor: Colors.deepPurpleAccent,
      child: const Icon(Icons.directions),
    ));
  }
}