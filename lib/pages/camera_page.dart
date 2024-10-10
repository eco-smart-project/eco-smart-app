import 'package:camera/camera.dart';
import 'package:eco_smart/components/main_drawer.dart';
import 'package:eco_smart/core/constants.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRearCamera = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  CameraDescription getCamera(List<CameraDescription> cameras) {
    if (cameras.isEmpty) return cameras.first;

    CameraDescription backCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back, orElse: () => cameras.first);

    return backCamera;
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();

    _cameraController = CameraController(
      getCamera(_cameras!),
      ResolutionPreset.high,
    );

    await _cameraController?.initialize();
    setState(() {});
  }

  void _toggleCamera() {
    setState(() {
      _isRearCamera = !_isRearCamera;
    });

    final selectedCamera = _cameras!.firstWhere((camera) => camera.lensDirection == (_isRearCamera ? CameraLensDirection.back : CameraLensDirection.front));
    _cameraController = CameraController(selectedCamera, ResolutionPreset.high);

    _cameraController?.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _capturePhoto() async {
    if (!_cameraController!.value.isInitialized) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      print('Foto capturada: ${photo.path}');
    } catch (e) {
      print('Erro ao capturar foto: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text('Identificação de Resíduos'),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_cameraController!),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _toggleCamera,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(15),
                              backgroundColor: Colors.white,
                            ),
                            child: Icon(Icons.switch_camera_rounded, size: 30, color: Theme.of(context).primaryColor),
                          ),
                          ElevatedButton(
                            onPressed: _capturePhoto,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(15),
                              backgroundColor: Colors.white,
                            ),
                            child: Icon(Icons.camera_alt_rounded, size: 30, color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
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
}
