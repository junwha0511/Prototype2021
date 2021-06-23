import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prototype2021/settings/constants.dart';

class GooglePlaceData {
  Map<String, dynamic>
      placeMeta; //{business_status, geometry: {location: lat, lng,}, viewport: {northeast, southest}, icon, name, opening_hours, photos, place_id, plus_code: {compound_code, global_code}, price_level, rating, reference, scope, types, user_ratings_total, vicinty}
  String type;

  GooglePlaceData(this.placeMeta, this.type);

  LatLng get location => LatLng(placeMeta["geometry"]["location"]["lat"],
      placeMeta["geometry"]["location"]["lng"]);

  String get name => placeMeta["name"];
  String get businessStatus => placeMeta["business_status"];
  String get userRatingsTotal => placeMeta["user_ratings_total"];
  String get types => placeMeta["types"];
  String? get photo => placeMeta.containsKey("photos")
      ? "https://maps.googleapis.com/maps/api/place/photo?photoreference=${placeMeta["photos"][0]["photo_reference"]}&key=$kGoogleApiKey&maxwidth=200"
      : null;
}