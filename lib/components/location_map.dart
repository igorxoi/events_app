import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationMap extends StatefulWidget {
  final double eventLatitude;
  final double eventLongitude;
  final double height;

  const LocationMap({
    super.key,
    required this.eventLatitude,
    required this.eventLongitude,
    this.height = 200,
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      await _requestLocationPermission();
      await _getCurrentLocation();
      _addMarkers();
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      throw Exception('Permissão de localização negada');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      throw Exception('Não foi possível obter a localização atual');
    }
  }

  void _addMarkers() {
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'Sua localização'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    _markers.add(
      Marker(
        markerId: const MarkerId('event_location'),
        position: LatLng(widget.eventLatitude, widget.eventLongitude),
        infoWindow: const InfoWindow(title: 'Local do evento'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('Erro ao carregar o mapa')),
      );
    }

    LatLngBounds bounds;
    if (_currentPosition != null) {
      bounds = LatLngBounds(
        southwest: LatLng(
          _currentPosition!.latitude < widget.eventLatitude
              ? _currentPosition!.latitude
              : widget.eventLatitude,
          _currentPosition!.longitude < widget.eventLongitude
              ? _currentPosition!.longitude
              : widget.eventLongitude,
        ),
        northeast: LatLng(
          _currentPosition!.latitude > widget.eventLatitude
              ? _currentPosition!.latitude
              : widget.eventLatitude,
          _currentPosition!.longitude > widget.eventLongitude
              ? _currentPosition!.longitude
              : widget.eventLongitude,
        ),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(
          widget.eventLatitude - 0.01,
          widget.eventLongitude - 0.01,
        ),
        northeast: LatLng(
          widget.eventLatitude + 0.01,
          widget.eventLongitude + 0.01,
        ),
      );
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.eventLatitude, widget.eventLongitude),
          zoom: 13,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
