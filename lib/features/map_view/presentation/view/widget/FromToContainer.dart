import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class FromToContainer extends StatelessWidget {

  final PlaceDetails end;
  final LatLng start;
  final double distance;
  final Function(Location) onTab;

  const FromToContainer({
  required this.start,
  required this.distance,
  required this.onTab
  ,required this.end,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
    top: size.height*0.06,
    right: size.width*0.065
    ,child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children:  [
            const DirectionTextWidget(text: "From"),
            const SizedBox(width: 5,),
            DirectionTextWidget(text: "Your Location",width: 160,onTab: ()=>onTab(Location(lat: start.latitude,lng:start.longitude))),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 11.0),
              child: Icon(Icons.arrow_downward_rounded,color: Colors.deepPurpleAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 42.0),
              child: Text("Distance: ${distance.toInt().toString()} km",style: const TextStyle(color: Colors.deepPurple)),
            ),
          ],
        ),

        Row(
          children: [
            const DirectionTextWidget(text: "To"),
            const SizedBox(width: 5,),
            DirectionTextWidget(text: end.name.toString(),width: 160,
            onTab: ()=>onTab(Location(lat: end.geometry!.location.lat, lng: end.geometry!.location.lng)),
            ),
          ],
        ),
      ],
    ));
  }
}

class DirectionTextWidget extends StatelessWidget {

  final String text;
  final double width;
  final double height;
  final Function()? onTab;
  const DirectionTextWidget({
    super.key,
    required this.text,
    this.height=30,
    this.width=45,
    this.onTab
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(width: width,height: height,decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(36)
      ), child: Center(child: Text(text,style: const TextStyle(color: Colors.white),))),
    );
  }
}
