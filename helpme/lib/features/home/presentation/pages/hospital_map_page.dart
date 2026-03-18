import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalMapPage extends StatefulWidget {
  const HospitalMapPage({super.key});

  @override
  State<HospitalMapPage> createState() => _HospitalMapPageState();
}

class _HospitalMapPageState extends State<HospitalMapPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndGetLocation();
  }

  Future<void> _checkPermissionsAndGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable them.';
          _isLoading = false;
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Location permissions are permanently denied, we cannot request permissions.';
          _isLoading = false;
        });
        return;
      }

      // Permissions are granted, get the position.
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Add marker for current user location
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );

      // Move camera
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            13.0,
          ),
        );
      }

      await _fetchNearbyFacilities();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNearbyFacilities() async {
    final apiKey = dotenv.env['Google_map'];
    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        _errorMessage = 'Google Maps API key is missing from .env file';
        _isLoading = false;
      });
      return;
    }

    if (_currentPosition == null) return;

    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;
    final radius = 5000; // 5km search radius

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch Hospitals
      await _searchPlaces(
        lat,
        lng,
        radius,
        'hospital',
        apiKey,
        BitmapDescriptor.hueRed,
      );
      // Fetch Psychologists/Therapists
      await _searchPlaces(
        lat,
        lng,
        radius,
        'psychologist',
        apiKey,
        BitmapDescriptor.hueOrange,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch places: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchPlaces(
    double lat,
    double lng,
    int radius,
    String type,
    String apiKey,
    double markerHue,
  ) async {
    // We use Text Search because Nearby Search has limited categories or might not find exactly "psychologist"
    // Wait, using keyword is better for Nearby Search
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&keyword=$type&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'] != null) {
        for (var result in data['results']) {
          final location = result['geometry']['location'];
          final String name = result['name'] ?? 'Unknown Facility';
          final String placeId = result['place_id'] ?? '';

          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId(placeId.isNotEmpty ? placeId : name),
                position: LatLng(location['lat'], location['lng']),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: type.toUpperCase(),
                  onTap: () {
                    // Could open in external map if deep linking is desired
                    _openExternalMap(location['lat'], location['lng'], name);
                  },
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
              ),
            );
          });
        }
      }
    }
  }

  Future<void> _openExternalMap(double lat, double lng, String name) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          'Nearby Help',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  _checkPermissionsAndGetLocation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8DBDBA),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition != null
                ? LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  )
                : const LatLng(0, 0),
            zoom: 2,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: _markers,
          onMapCreated: (controller) {
            _mapController = controller;
            if (_currentPosition != null) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  13.0,
                ),
              );
            }
          },
        ),
        if (_isLoading)
          Container(
            color: Colors.white.withOpacity(0.8),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF8DBDBA),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Fetching nearby hospitals and psychologists...'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
