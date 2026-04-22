import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'device_location.dart';
import 'safe_route_search.dart';
import 'area_safety_checking.dart';
import 'crowd_reporting.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedPoint;

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Amar ProtikKha Map"),
        actions: [
          if (selectedPoint != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => selectedPoint = null),
              tooltip: "Clear selection",
            )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: locationData.currentLocation,
              initialZoom: 13.0,
              // Update state when user picks a location
              onLongPress: (tapPosition, point) => setState(() => selectedPoint = point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                // CRITICAL: Many providers require a User Agent to serve tiles
                userAgentPackageName: 'com.example.amar_protikkha',
              ),
              MarkerLayer(
                markers: [
                  // User's Current Location
                  Marker(
                    point: locationData.currentLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                  ),
                  // The Point User wants to check/report
                  if (selectedPoint != null)
                    Marker(
                      point: selectedPoint!,
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 30, left: 10, right: 10,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _navBtn(Icons.directions, "Route", SafeRouteSearch(target: selectedPoint)),
                    _navBtn(Icons.security, "Safety", AreaSafetyChecking(point: selectedPoint)),
                    _navBtn(Icons.group, "Crowd", CrowdReporting(point: selectedPoint)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, String label, Widget screen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: selectedPoint == null ? Colors.grey : Colors.blueAccent), 
          onPressed: () {
            if (selectedPoint == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please long-press on map to select a location first!"))
              );
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
            }
          }
        ),
        Text(label, style: TextStyle(fontSize: 10, color: selectedPoint == null ? Colors.grey : Colors.black)),
      ],
    );
  }
}