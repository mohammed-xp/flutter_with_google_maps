import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/widgets/custom_google_map.dart';

void main() {
  runApp(const FlutterWithGoogleMaps());
}

class FlutterWithGoogleMaps extends StatelessWidget {
  const FlutterWithGoogleMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CustomGoogleMap(),
    );
  }
}
