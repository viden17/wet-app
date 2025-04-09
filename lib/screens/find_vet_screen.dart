import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FindVetScreen extends StatefulWidget {
  const FindVetScreen({super.key});

  @override
  State<FindVetScreen> createState() => _FindVetScreenState();
}

class _FindVetScreenState extends State<FindVetScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoading = true;
  bool _hasLocationPermission = false;
  String? _errorMessage;
  
  // This will need to be configured before the feature works
  final String? apiKey = null; // Set to null to indicate it's not configured

  @override
  void initState() {
    super.initState();
    _checkApiKeyAndLocation();
  }

  Future<void> _checkApiKeyAndLocation() async {
    // Check if API key is provided
    if (apiKey == null || apiKey!.isEmpty || apiKey == 'YOUR_GOOGLE_MAPS_API_KEY') {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Google Maps API key not configured';
      });
      return;
    }

    // Check location permissions
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _hasLocationPermission = false;
          _errorMessage = 'Location permission required to find nearby vets';
        });
        return;
      }

      setState(() {
        _hasLocationPermission = true;
      });
      
      await _getCurrentLocation();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error accessing location services: $e';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      
      _fetchNearbyVets(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to get current location: $e';
      });
    }
  }

  Future<void> _fetchNearbyVets(double lat, double lng) async {
    if (apiKey == null || apiKey!.isEmpty || apiKey == 'YOUR_GOOGLE_MAPS_API_KEY') {
      return; // Don't attempt API call without valid key
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=5000&keyword=veterinary|pet&key=$apiKey'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'REQUEST_DENIED') {
          setState(() {
            _isLoading = false;
            _errorMessage = 'API request denied: ${data['error_message']}';
          });
          return;
        }
        
        setState(() {
          _markers = Set<Marker>.from(
            (data['results'] as List).map((place) {
              return Marker(
                markerId: MarkerId(place['place_id']),
                position: LatLng(
                  place['geometry']['location']['lat'],
                  place['geometry']['location']['lng']
                ),
                infoWindow: InfoWindow(
                  title: place['name'],
                  snippet: place['vicinity'],
                  onTap: () => _showPlaceDetails(place['place_id']),
                ),
              );
            })
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load nearby veterinarians';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching vet data: $e';
      });
    }
  }

  Future<void> _showPlaceDetails(String placeId) async {
    if (apiKey == null || apiKey!.isEmpty || apiKey == 'YOUR_GOOGLE_MAPS_API_KEY') {
      return; // Don't attempt API call without valid key
    }
    
    try {
      final detailUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'
      );
      
      final response = await http.get(detailUrl);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'REQUEST_DENIED') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('API request denied: ${data['error_message']}'))
          );
          return;
        }
        
        final place = data['result'];
        
        showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 8),
                Text(place['formatted_address'] ?? 'Address not available'),
                SizedBox(height: 4),
                Text('Phone: ${place['formatted_phone_number'] ?? "Not available"}'),
                SizedBox(height: 4),
                Text('Rating: ${place['rating']?.toString() ?? "Not rated"} (${place['user_ratings_total'] ?? 0} reviews)'),
                if (place['opening_hours'] != null) ...[
                  SizedBox(height: 8),
                  Text(
                    place['opening_hours']['open_now'] == true
                      ? 'Open now'
                      : 'Closed now',
                    style: TextStyle(
                      color: place['opening_hours']['open_now'] == true
                        ? Colors.green
                        : Colors.red,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load place details'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching place details: $e'))
      );
    }
  }

  Widget _buildApiKeyMissingUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 24),
            Text(
              'Google Maps API Key Required',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'To use the Find Vet feature, a Google Maps API key needs to be configured.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Show instructions dialog for obtaining API key
                _showApiKeyInstructions();
              },
              child: Text('How to Get an API Key'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showApiKeyInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Setting Up Google Maps API'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '1. Go to the Google Cloud Console',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('2. Create a new project or select an existing one'),
                SizedBox(height: 8),
                Text('3. Enable the following APIs:'),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Google Maps SDK for Android/iOS'),
                      Text('• Places API'),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text('4. Create an API key with appropriate restrictions'),
                SizedBox(height: 8),
                Text('5. Add the API key to the app configuration'),
                SizedBox(height: 16),
                Text(
                  'For security reasons, restrict your API key to only the APIs and mobile platforms you need.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Find a Vet",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
       
          
        
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null && _errorMessage!.contains('API key')
              ? _buildApiKeyMissingUI()
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _checkApiKeyAndLocation,
                              child: Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _currentPosition == null
                      ? Center(child: Text('Unable to get location'))
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            zoom: 14,
                          ),
                          myLocationEnabled: true,
                          markers: _markers,
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                        ),
    );
  }
}