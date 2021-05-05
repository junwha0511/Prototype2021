import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prototype2021/model/map_place.dart';
import 'package:prototype2021/ui/marker_list.dart';
import 'package:prototype2021/ui/location.dart';
import 'package:prototype2021/ui/content_location.dart';
import 'package:http/http.dart' as http;

class LocationModel with ChangeNotifier {
  List<Location> locations = [
    ContentLocation(0, "A", LatLng(37.5172, 127.0473))
  ];

  MarkerList markerList = MarkerList();
  bool loaded = false;
  LatLng center;
  late PlaceLoader placeLoader;

  LocationModel({required this.center}) {
    init();
  }

  void init() async {
    loaded = await markerList.loadImage();
    this.placeLoader = PlaceLoader(center: this.center);
    List<PlaceData> placeDataList =
        await placeLoader.getPlaces([RESTAURANT, HOTEL, SPOT]);
    for (PlaceData placeData in placeDataList) {
      locations.add(ContentLocation(
          locations.length, placeData.name, placeData.location));
    }

    markerList.addMarkerList(locations);
    notifyListeners();
  }

  void loadData() {}

  Set<Marker> get markers =>
      markerList.markerList; //TODO: consider update location with efficiency

  /*
  * Update locations field with the locations included in boundary of bounds.
  */

  void setBearing(double bearing) {
    markerList.bearing = bearing;
    markerList.removeAll();
    markerList.addMarkerList(locations);
    notifyListeners();
  }

  void updateLocations(LatLngBounds bounds) {
    //TODO(junwha): call this method when map changed action detected.
    //bounds.southwest; bounds.northeast;

    if (isUpdate(bounds)) {
      notifyListeners();
    } else {}
  }

  bool isUpdate(LatLngBounds bounds) {
    return false;
  }

  void updateMarkers() {}

  void findNearByPlaces() {}
}
