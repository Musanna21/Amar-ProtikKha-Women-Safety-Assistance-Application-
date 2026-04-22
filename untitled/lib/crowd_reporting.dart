// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class CrowdReporting extends StatefulWidget {
  final LatLng? point;
  const CrowdReporting({super.key, this.point});
  @override
  State<CrowdReporting> createState() => _CrowdReportingState();
}

class _CrowdReportingState extends State<CrowdReporting> {
  final TextEditingController _controller = TextEditingController();
  // This will store all crowed roports in crowed_report_storage.txt which will be located in 'Documents' folder for desktops and app data in android and ios.
  Future<void> _submitReport() async {
    if (widget.point == null || _controller.text.isEmpty) return;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/crowed_report_storage.txt');
    final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    String entry ="[$time] LOCATION: ${widget.point!.latitude}, ${widget.point!.longitude}\nREVIEW: ${_controller.text}\n------------------\n";
    await file.writeAsString(entry, mode: FileMode.append);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Safety Report Logged Successfully")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Reporting for: ${widget.point?.latitude}, ${widget.point?.longitude}",
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Describe safety concerns...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReport,
              child: const Text("Submit Review"),
            ),
          ],
        ),
      ),
    );
  }
}
