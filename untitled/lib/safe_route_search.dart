import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'gemini_service.dart';
import 'device_location.dart';

class SafeRouteSearch extends StatefulWidget {
  final LatLng? target;
  const SafeRouteSearch({super.key, this.target});
  @override
  State<SafeRouteSearch> createState() => _SafeRouteSearchState();
}

class _SafeRouteSearchState extends State<SafeRouteSearch> {
  String _routeData = "Point to a destination on the map.";

  void _fetchSafeRoute() async {
    if (widget.target == null) return;
    setState(() => _routeData = "Calculating safest path with AI...");
    
    final response = await GeminiService().getAssistantResponse(
      userInput: "Suggest safest route to: ${widget.target!.latitude}, ${widget.target!.longitude}",
      mode: AssistantMode.route,
      location: Provider.of<LocationProvider>(context, listen: false),
    );
    setState(() => _routeData = response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Safe Route Search")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Destination: ${widget.target?.latitude ?? 'None selected'}"),
            ElevatedButton(onPressed: widget.target != null ? _fetchSafeRoute : null, child: const Text("Get Safe Path")),
            const Divider(),
            Expanded(child: SingleChildScrollView(child: Text(_routeData))),
          ],
        ),
      ),
    );
  }
}