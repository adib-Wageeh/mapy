import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMapWidget extends StatelessWidget {
  final Set<Polyline>? polylines;
  final LatLng latLng;
  const ShowMapWidget({
    super.key,
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
                latLng.latitude,latLng.longitude)
        )
      },
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        zoom: 14.151926040649414
        ,target:LatLng(
          latLng.latitude,latLng.longitude),),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
