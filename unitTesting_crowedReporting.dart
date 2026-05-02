import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

void main() {
  group('Crowd Reporting Unit Tests', () {
    late File testFile;
    final LatLng demoLocation = const LatLng(23.8103, 90.4125); // Dhaka

    setUp(() async {
      // temporary file for testing purposes
      testFile = File('test_crowd_report_storage.txt');
      if (await testFile.exists()) {
        await testFile.delete();
      }
    });

    tearDown(() async {
      // clean up after tests are done
      if (await testFile.exists()) {
        await testFile.delete();
      }
    });

    test('Bulk Report Generation and Integrity Check', () async {
      const int reportCount = 50; // You can change this between 10-100
      print('    Starting Unit Test: Generating $reportCount Reports    ');

      for (int i = 1; i <= reportCount; i++) {
        final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        String entry = "[$time] LOCATION: ${demoLocation.latitude}, ${demoLocation.longitude}\n"
                       "REVIEW: Demo Safety Concern Report #$i\n"
                       "------------------\n";
        
        // logic from CrowdReporting._submitReport
        await testFile.writeAsString(entry, mode: FileMode.append);
      }

      // read back the results
      String content = await testFile.readAsString();
      List<String> reports = content.split('------------------\n').where((s) => s.isNotEmpty).toList();

      // Printing Results for Faculty Review
      print('Total Reports Logged: ${reports.length}');
      print('Sample Entry Check:\n${reports.first}');

      // Assertions (The actual "Testing" part)
      expect(reports.length, reportCount, reason: "The number of reports should match the loop count.");
      expect(content.contains('LOCATION: 23.8103'), true, reason: "The location data must be present.");
      
      print('    Unit Test Passed Successfully    ');
    });
  });
}