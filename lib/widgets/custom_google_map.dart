import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/models/place_model.dart';
import 'package:flutter_with_google_maps/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;

  GoogleMapController? googleMapController;

  late LocationService locationService;

  Set<Marker> markers = {};

  Set<Polygon> polygons = {};

  Set<Polyline> polyLines = {};

  Set<Circle> circles = {};

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(15.559288419880392, 32.58382793767906),
      zoom: 17,
    );

    locationService = LocationService();

    // checkAndRequestLocationService().then((v) {
    //   checkAndRequestLocationPermission();
    // });

    initMyLocation();

    initMarkers();

    initPolygons();

    initPolyLines();

    initCircles();

    super.initState();
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          polygons: polygons,
          polylines: polyLines,
          circles: circles,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            googleMapController = controller;

            initMapStyle();

            // location.onLocationChanged.listen((locationData) {});
          },
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          // cameraTargetBounds: CameraTargetBounds(
          //   LatLngBounds(
          //     northeast: const LatLng(15.576617743224622, 32.55716502480021),
          //     southwest: const LatLng(15.549907119325981, 32.59643051876622),
          //   ),
          // ),
        ),
        Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                googleMapController?.animateCamera(
                  CameraUpdate.newLatLng(
                    const LatLng(15.461677875456532, 32.486278963879435),
                  ),
                );
              },
              child: const Text(
                'Change Location',
              ),
            )),
      ],
    );
  }

  bool isFirstCall = true;

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style/night_map_style.json');

    googleMapController!.setMapStyle(nightMapStyle);
  }

  void initMarkers() async {
    var customMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/icons8-marker-96.png',
      width: 40,
    );
    var myMarkers = places
        .map(
          (p) => Marker(
            markerId: MarkerId(p.id.toString()),
            position: p.latLng,
            infoWindow: InfoWindow(title: p.name),
            icon: customMarkerIcon,
          ),
        )
        .toSet();

    markers.addAll(myMarkers);

    setState(() {});
  }

  void initPolygons() {
    var polygon = Polygon(
      polygonId: const PolygonId('1'),
      holes: const [
        [
          LatLng(15.559288419880392, 32.58382793767906),
          LatLng(15.559822635942558, 32.58570398728057),
          LatLng(15.558283947085524, 32.58814183903209),
        ]
      ],
      points: const [
        LatLng(15.562404993452995, 32.585875447768636),
        LatLng(15.559289047856147, 32.573041145198054),
        LatLng(15.549662972571921, 32.57757790337359),
        LatLng(15.55032182641657, 32.596313896803814),
      ],
      strokeWidth: 5,
      // strokeColor: Colors.red,
      fillColor: Colors.red.withOpacity(0.5),
    );

    polygons.add(polygon);
  }

  void initPolyLines() {
    var polyLine = const Polyline(
      polylineId: PolylineId('1'),
      startCap: Cap.roundCap,
      zIndex: 2,
      points: [
        LatLng(15.559288419880392, 32.58382793767906),
        LatLng(15.559822635942558, 32.58570398728057),
        LatLng(15.558283947085524, 32.58814183903209),
      ],
      color: Colors.red,
      width: 5,
    );

    var polyLine2 = const Polyline(
      polylineId: PolylineId('2'),
      startCap: Cap.roundCap,
      zIndex: 1,
      geodesic: true,
      patterns: [
        PatternItem.dot,
      ],
      points: [
        LatLng(15.55845306277801, 32.585159257646175),
        LatLng(62.320698113154066, 92.844903219031),
        // LatLng(15.56021298311716, 32.58147789723053),
        // LatLng(15.559041021248838, 32.58534848094706),
      ],
      color: Colors.green,
      width: 5,
    );

    polyLines.add(polyLine);
    polyLines.add(polyLine2);
  }

  void initCircles() {
    var circle = Circle(
      circleId: const CircleId('1'),
      center: const LatLng(15.548467050470562, 32.588965403642895),
      radius: 100,
      strokeWidth: 5,
      strokeColor: Colors.red,
      fillColor: Colors.red.withOpacity(0.5),
    );

    circles.add(circle);
  }

  void initMyLocation() async {
    await locationService.checkAndRequestLocationService();
    bool hasPermission =
        await locationService.checkAndRequestLocationPermission();
    if (hasPermission) {
      locationService.getRealTimeLocation((locationData) {
        var latLng = LatLng(
          locationData.latitude!,
          locationData.longitude!,
        );
        setMylocationMarker(latLng);
        setMyLocationCameraPosition(latLng);
      });
    } else {}
  }

  void setMyLocationCameraPosition(LatLng latLng) {
    if (isFirstCall) {
      CameraPosition cameraPosition = CameraPosition(
        target: latLng,
        zoom: 17,
      );

      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    } else {
      googleMapController?.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    }
  }

  void setMylocationMarker(LatLng latLng) {
    var myLocationMarker = Marker(
      markerId: const MarkerId('myLocation'),
      position: latLng,
      infoWindow: const InfoWindow(title: 'My Location'),
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.add(myLocationMarker);

    setState(() {});
  }
}

// Zoom Levels:
// world view 0 - 3
// country view 4 - 6
// city view 10 - 12
// street view 13 - 17
// building view 18 - 20

/// Steps to get location:
/// 1- inquire about location service
/// 2- request permession
/// 3- get location
/// 4- display location
