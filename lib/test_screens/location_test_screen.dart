// Simple UI test for LocationService
// Add this to your main.dart temporarily or create a separate test app

import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationTestScreen extends StatefulWidget {
  const LocationTestScreen({super.key});

  @override
  _LocationTestScreenState createState() => _LocationTestScreenState();
}

class _LocationTestScreenState extends State<LocationTestScreen> {
  final LocationService _locationService = LocationService();
  Position? _currentPosition;
  String _status = 'Ready to test location';
  bool _isLoading = false;

  Future<void> _testLocation() async {
    setState(() {
      _isLoading = true;
      _status = 'Requesting location...';
      _currentPosition = null;
    });

    try {
      Position? position = await _locationService.getCurrentLocation();
      
      setState(() {
        _isLoading = false;
        if (position != null) {
          _currentPosition = position;
          _status = 'Location retrieved successfully!';
        } else {
          _status = 'Failed to get location. Check permissions.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Service Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(_status),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _testLocation,
              child: _isLoading 
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Getting Location...'),
                    ],
                  )
                : Text('Test Location Service'),
            ),
            
            SizedBox(height: 16),
            
            if (_currentPosition != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Details:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildDetailRow('Latitude', '${_currentPosition!.latitude}'),
                      _buildDetailRow('Longitude', '${_currentPosition!.longitude}'),
                      _buildDetailRow('Accuracy', '${_currentPosition!.accuracy.toStringAsFixed(2)} meters'),
                      _buildDetailRow('Altitude', '${_currentPosition!.altitude.toStringAsFixed(2)} meters'),
                      _buildDetailRow('Speed', '${_currentPosition!.speed.toStringAsFixed(2)} m/s'),
                      _buildDetailRow('Heading', '${_currentPosition!.heading.toStringAsFixed(2)}°'),
                      _buildDetailRow('Timestamp', '${_currentPosition!.timestamp}'),
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 16),
            
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Instructions:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Make sure location services are enabled'),
                    Text('2. Grant location permissions when prompted'),
                    Text('3. For best results, test outdoors or near a window'),
                    Text('4. Check that coordinates are within valid ranges'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// To use this, add to your main.dart:
// home: LocationTestScreen(),
