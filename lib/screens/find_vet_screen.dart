import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class FindvetScreen extends StatefulWidget {
  @override
  _FindvetScreenState createState() => _FindvetScreenState();
}

class _FindvetScreenState extends State<FindvetScreen> {
  static const _apiKey = 'AIzaSyCVRj27DSJKoWjBtnvHKUZptljkGvqHZkQ';
  final Completer<GoogleMapController> _mapController = Completer();
  Position? _currentPosition;
  List<Place> _places = [];
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initLocationAndFetch();
  }

  Future<void> _initLocationAndFetch() async {
    // 1. Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // 2. If denied, request it
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 3a. If still denied, inform the user and stop
    if (permission == LocationPermission.denied) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Permission required'),
          content: Text(
            'Location permission is required to find nearby vet clinics. '
            'Please allow location access.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // 3b. If permanently denied, prompt to open settings
    if (permission == LocationPermission.deniedForever) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Permission required'),
          content: Text(
            'Location permission has been permanently denied. '
            'Please enable it from the app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('Open Settings'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
      return;
    }

    // 4. Permission granted – get the current position
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return;
    }

    // 5. Finally, fetch nearby vet clinics
    await _fetchNearbyVets();
  }

  Future<void> _fetchNearbyVets() async {
    if (_currentPosition == null) return;

    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/nearbysearch/json',
      {
        'location':
            '${_currentPosition!.latitude},${_currentPosition!.longitude}',
        'radius': '2000',                  // 2 km radius
        'type': 'veterinary_care',         // vet-care hospitals
        'key': _apiKey,
      },
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final results = data['results'] as List;
      _places = results.map((j) => Place.fromJson(j)).toList();

      _markers = _places.map((p) {
        return Marker(
          markerId: MarkerId(p.placeId),
          position: LatLng(p.lat, p.lng),
          infoWindow: InfoWindow(title: p.name, snippet: p.vicinity),
        );
      }).toSet();

      setState(() {});
    } else {
      print('Places API error: ${data['status']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialCamera = CameraPosition(
      target: _currentPosition != null
          ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
          : LatLng(0, 0),
      zoom: 14,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Find Nearbly Vet Care Centers",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50), // Green theme
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Google Map view
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: initialCamera,
                    myLocationEnabled: true,
                    markers: _markers,
                    onMapCreated: (controller) =>
                        _mapController.complete(controller),
                  ),
                ),
                // Scrollable list of vets
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: _places.length,
                    itemBuilder: (ctx, i) {
                      final place = _places[i];
                      return ListTile(
                        leading: Icon(Icons.local_hospital),
                        title: Text(place.name),
                        subtitle: Text(place.vicinity),
                        onTap: () async {
                          final ctrl = await _mapController.future;
                          ctrl.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(place.lat, place.lng),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

/// Model for a Place from Google Places API
class Place {
  final String placeId;
  final String name;
  final String vicinity;
  final double lat;
  final double lng;

  Place({
    required this.placeId,
    required this.name,
    required this.vicinity,
    required this.lat,
    required this.lng,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final loc = json['geometry']['location'];
    return Place(
      placeId: json['place_id'],
      name: json['name'],
      vicinity: json['vicinity'],
      lat: loc['lat'],
      lng: loc['lng'],
    );
  }
}