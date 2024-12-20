import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({required this.id, required this.name, required this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: "منزلي",
    latLng: const LatLng(15.559374017431528, 32.58384344516877),
  ),
  PlaceModel(
    id: 2,
    name: "بقالة جوهرة الستين",
    latLng: const LatLng(15.557616255144046, 32.58028596181518),
  ),
  PlaceModel(
    id: 3,
    name: "مسجد علي الحلبي",
    latLng: const LatLng(15.559822635942558, 32.58570398728057),
  ),
];
