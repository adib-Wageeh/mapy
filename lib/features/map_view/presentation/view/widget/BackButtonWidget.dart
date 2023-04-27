import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewModel/viewMap/view_map_cubit.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height*0.08,
      left: size.width*0.065
      ,child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color: Colors.deepPurpleAccent),
        child: IconButton(
        padding: EdgeInsets.zero
        ,onPressed: ()async{
        await BlocProvider.of<ViewMapCubit>(context).getCurrentLocation();
    },
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_sharp)),
      ),
    );
  }
}