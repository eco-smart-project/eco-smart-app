import 'dart:async';

import 'package:eco_smart/components/main_drawer.dart';
import 'package:eco_smart/core/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isLoading = false;
  final Completer<GoogleMapController> _mapController = Completer();
  List<Marker> _markers = [];
  Location location = Location();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final markerIcon1 = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/garbage-type-icons/default.png',
    );
    final markerIcon2 = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/garbage-type-icons/glass.png',
    );
    final markerIcon3 = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/garbage-type-icons/eletronic.png',
    );

    setState(() {
      _markers = [
        Marker(
          markerId: const MarkerId('ponto1'),
          position: const LatLng(-23.55052, -46.63331),
          infoWindow: const InfoWindow(
            title: 'Ponto de Coleta 1',
            snippet: 'Coleta de plásticos e papéis',
          ),
          icon: markerIcon1,
        ),
        Marker(
          markerId: const MarkerId('ponto2'),
          position: const LatLng(-23.55103, -46.64048),
          infoWindow: const InfoWindow(
            title: 'Ponto de Coleta 2',
            snippet: 'Coleta de metais e vidros',
          ),
          icon: markerIcon2,
        ),
        Marker(
          markerId: const MarkerId('ponto3'),
          position: const LatLng(-23.55439, -46.62970),
          infoWindow: const InfoWindow(
            title: 'Ponto de Coleta 3',
            snippet: 'Coleta de resíduos eletrônicos',
          ),
          icon: markerIcon3,
        ),
      ];
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void _centerMapOnUserLocation() async {
    setState(() {
      _isLoading = true;
    });

    var userLocation = await location.getLocation();
    LatLng currentPosition = LatLng(userLocation.latitude!, userLocation.longitude!);

    _mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLng(currentPosition),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text('Pontos de Coleta'),
              leading: Builder(
                builder: (context) {
                  return constraints.maxWidth <= WIDTH_OPEN_DRAWER
                      ? IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          })
                      : const SizedBox.shrink();
                },
              )),
          drawer: constraints.maxWidth <= WIDTH_OPEN_DRAWER ? const MainDrawer() : null,
          body: Row(
            children: [
              if (constraints.maxWidth > WIDTH_OPEN_DRAWER) const MainDrawer(rounded: false, isMobile: false),
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(-23.55052, -46.63331),
                        zoom: 13,
                      ),
                      markers: Set.from(_markers),
                    ),
                    if (isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: ElevatedButton(
                        onPressed: _centerMapOnUserLocation,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Icon(Icons.my_location, size: 30, color: Colors.white),
                      ),
                    ),
                    if (_isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController.future.then((controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
