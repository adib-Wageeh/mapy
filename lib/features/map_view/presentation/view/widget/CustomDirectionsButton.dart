import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';
import '../../viewModel/viewMap/view_map_cubit.dart';

class CustomDirectionsButton extends StatelessWidget {

  final PlaceDetails end;
  const CustomDirectionsButton({required this.end,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
        bottom: size.height*0.05,
        left: size.width*0.065
        ,child: FloatingActionButton(onPressed: () async{
      await BlocProvider.of<ViewMapCubit>(context).viewDirections(end,context);
    },
      backgroundColor: Colors.deepPurpleAccent,
      child: const Icon(Icons.directions),
    ));
  }
}