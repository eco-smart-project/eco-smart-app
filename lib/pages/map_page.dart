import 'dart:async';

import 'package:eco_smart/components/main_drawer.dart';
import 'package:eco_smart/core/constants.dart';
import 'package:eco_smart/models/request.dart';
import 'package:eco_smart/models/response.dart';
import 'package:eco_smart/services/request_service.dart';
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
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Request request = Request(
        method: 'GET',
        route: 'collection-points',
      );
      Response response = await RequestService().sendRequest(request);
      if (response.status == 200) {
        List<dynamic> points = response.data;
        var markers = points.map((point) async {
          return Marker(
            markerId: MarkerId(point['id'].toString()),
            position: LatLng(point['position']['latitude'], point['position']['longitude']),
            infoWindow: InfoWindow(
              title: point['title'],
              snippet: point['description'],
            ),
            icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(48, 48)),
              point['icon']
            ),
          );
        }).toList();

        // Wait for all markers to be created
        _markers = await Future.wait(markers);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e, stack) {
      print(e);
      print(stack);
      setState(() {
        _isLoading = false;
      });
    }
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
