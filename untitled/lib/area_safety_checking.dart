import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'gemini_service.dart';
import 'device_location.dart';

class AreaSafetyChecking extends StatefulWidget {
  final LatLng? point;
  const AreaSafetyChecking({super.key, this.point});

  @override
  State<AreaSafetyChecking> createState() => _AreaSafetyCheckingState();
}

class _AreaSafetyCheckingState extends State<AreaSafetyChecking> {
  String _analysis = "Please select a point on the map first.";

  void _runAiAnalysis() async {
    if (widget.point == null) return;
    setState(() => _analysis = "AI is evaluating area safety...");
    
    final response = await GeminiService().getAssistantResponse(
      userInput: "Analyze safety for location: ${widget.point!.latitude}, ${widget.point!.longitude}",
      mode: AssistantMode.safety,
      location: Provider.of<LocationProvider>(context, listen: false),
    );
    setState(() => _analysis = response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Area Safety Audit")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Coordinate: ${widget.point?.latitude ?? 'N/A'}, ${widget.point?.longitude ?? 'N/A'}"),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: widget.point != null ? _runAiAnalysis : null, child: const Text("Get AI Audit")),
            const Divider(),
            Expanded(child: SingleChildScrollView(child: Text(_analysis))),
          ],
        ),
      ),
    );
  }
}