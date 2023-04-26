import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class ShowMapWidget extends StatelessWidget {
  final Set<Polyline>? polylines;
  final Location latLng;
  final LatLng? start;
  const ShowMapWidget({
    super.key,
    this.start,
    required this.latLng,
    this.polylines,
    required Completer<GoogleMapController> controller,
  }) : _controller = controller;

  final Completer<GoogleMapController> _controller;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      polylines: polylines??Set(),
      markers: {
        Marker(markerId: const MarkerId("value"),
            position: LatLng(
                latLng.lat,latLng.lng)
        ),
        (start != null)?Marker(markerId: const MarkerId("start"),
            position: LatLng(
                start!.latitude,start!.longitude)
        ):const Marker(markerId: MarkerId(""))

      },
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        zoom: 14.151926040649414
        ,target:LatLng(
          latLng.lat,latLng.lng),),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
