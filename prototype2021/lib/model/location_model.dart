import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prototype2021/model/map_place.dart';
import 'package:prototype2021/ui/marker.dart';
import 'package:prototype2021/model/location.dart';

class LocationModel with ChangeNotifier {
  List<Location> locations = [];
  Map<String, bool> isIncludeType = {
    PlaceType.RESTAURANT: false,
    PlaceType.HOTEL: false,
    PlaceType.SPOT: false,
    PlaceType.CAFFEE: false,
  };
  MarkerList markerList = MarkerList();

  bool mapLoaded = false;
  LatLng center;
  late PlaceLoader placeLoader;
  GoogleMapController? mapController;

  int radius = 1500;

  bool placeLoaded = false;

  LocationModel({required this.center}) {
    init();
  }

  void init() async {
    mapLoaded = await markerList.loadImage(); // Load Marker Icons
    this.placeLoader = PlaceLoader(center: this.center);
    notifyListeners();
  }

  void clearMap() {
    locations.clear();
    markerList.removeAll();
    notifyListeners();
  }

  void clearFilters() {
    isIncludeType = {
      PlaceType.RESTAURANT: false,
      PlaceType.HOTEL: false,
      PlaceType.SPOT: false,
      PlaceType.CAFFEE: false,
    };
    notifyListeners();
  }

  /*
   * Load Places with types and update locations  
   */
  Future<void> loadPlaces() async {
    placeLoaded = false;
    clearMap();
    notifyListeners();

    this.placeLoader.updateCenter(this.center);

    List<String> types = [];

    for (String type in isIncludeType.keys) {
      if (isIncludeType[type]!) {
        types.add(type);
      }
    }
    List<PlaceData> placeDataList = [];

    placeDataList = await placeLoader.getPlaces(types, radius: this.radius);

    // Find nearby places with specified types
    for (PlaceData placeData in placeDataList) {
      // Add all placeData to location list
      locations.add(ContentLocation(locations.length, placeData.name,
          placeData.location, placeData.type));
    }

    if (types.isNotEmpty) {
      updateMarkers();
    }
    placeLoaded = true;
    notifyListeners();
  }

  Set<Marker> get markers =>
      markerList.markerList; //TODO: consider update location with efficiency

  /*
   * Update bearing and rotate markers
   */
  void updateBearing(double bearing) {
    if (markerList.bearing != bearing) {
      markerList.bearing = bearing;
      updateMarkers();
    }
    placeLoaded = true;
    notifyListeners();
  }

  /*
   * Update locations field with the locations included in boundary of bounds.
   */
  void updateLocations(LatLngBounds bounds) {
    //TODO(junwha): call this method when map changed action detected.
    //bounds.southwest; bounds.northeast;

    if (isUpdate(bounds)) {
      notifyListeners();
    } else {}
  }

  void updateMarkers() {
    markerList.removeAll();
    markerList.addMarkerList(locations);
  }

  void updateCenter(LatLng center) {
    this.center = center;
    notifyListeners();
  }

  /*
   * When user clicked search result, this method would be called.
   */
  void moveToResult(String name, LatLng location) {
    clearMap();
    updateCenter(location);
    mapController?.moveCamera(
      CameraUpdate.newLatLng(
        location,
      ),
    );

    locations = [ContentLocation(0, name, location, PlaceType.DEFAULT)];
    updateMarkers();
    clearFilters();
    notifyListeners();
  }

  bool isUpdate(LatLngBounds bounds) {
    return false;
  }
}