import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prototype2021/ui/content_location.dart';
import 'package:prototype2021/ui/location.dart';
import 'package:flutter/material.dart';
import 'package:prototype2021/ui/custom_marker.dart';

class MarkerList {
  //TODO(junwha): generalize with CID and EID
  //Fields for Markers
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  int _markerIdCounter = 1;
  late BitmapDescriptor markerIcon; //= BitmapDescriptor.defaultMarker;

  Set<Marker> get markerList => Set<Marker>.of(markers.values);

  MarkerList() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)),
            'assets/images/map/marker.png')
        .then((onValue) {
      print("succeed");
      print(onValue.toJson());
      markerIcon = onValue;
    }).onError((error, stackTrace) {
      markerIcon = BitmapDescriptor.defaultMarker;
    });
  }

  void addMarkerList(List<Location> locationList) {
    // print(markerIcon);
    for (Location location in locationList) {
      if (location is ContentLocation) {
        addMarker(location.latLng);
      }
    }
  }

  //Add New Marker
  void addMarker(LatLng latLng) {
    final int markerCount = markers.length;

    //Set maximum of marker
    if (markerCount == 12) {
      return;
    }

    //marker ID
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    //Create Marker
    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        //_onMarkerDragEnd(markerId, position);
      },
      flat: true,
      icon: markerIcon,
    );

    markers[markerId] = marker;
  }

  void removeMarker(LatLng latLng) {}
}