import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';

import '../../viewModel/viewMap/view_map_cubit.dart';

class GetSavedDirectionsModalSheet extends StatefulWidget {

  Map<String,List<String>> locations;
  GetSavedDirectionsModalSheet({required this.locations,Key? key}) : super(key: key);

  @override
  State<GetSavedDirectionsModalSheet> createState() => _GetSavedDirectionsModalSheetState();
}

class _GetSavedDirectionsModalSheetState extends State<GetSavedDirectionsModalSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(

        height: 300,
        padding: const EdgeInsets.only(left: 12,right: 12,top: 22),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(36)),
        child: ListView.separated(itemBuilder: (context,index){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color: Colors.deepPurpleAccent),
                child: const Center(child: Text("To",style: TextStyle(color: Colors.white),)),
              ),
              const SizedBox(width: 10,),
              Container(
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color: Colors.deepPurpleAccent),
                width: 220,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      BlocProvider.of<ViewMapCubit>(context).viewDirections(PlaceDetails(name: widget.locations.keys.elementAt(index), placeId: widget.locations.values.elementAt(index)[0],geometry: Geometry(location: Location(lat: double.parse(widget.locations.values.elementAt(index)[1]), lng: double.parse(widget.locations.values.elementAt(index)[2])))), context);
                    },
                    borderRadius: BorderRadius.circular(36),
                    child: Center(child: Text(widget.locations.keys.elementAt(index),style: const TextStyle(color: Colors.white),)),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color: Colors.red),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: ()async{
                        widget.locations = await BlocProvider.of<ViewMapCubit>(context).deleteDirection(widget.locations.keys.elementAt(index));
                        setState(() {
                        });
                      },
                      borderRadius: BorderRadius.circular(36),
                      child: const Center(child: Icon(Icons.delete,color: Colors.white,))),
                ),
              ),
            ],
          );
        },
          separatorBuilder: (context,index){
            return const SizedBox(height: 10,);
          },itemCount: widget.locations.length,
        ),

      ),
    );
  }
}