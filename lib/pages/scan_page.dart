import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'setup_page.dart';
import 'about_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _hasPermission = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAfterSettings();
    }
  }

  Future<void> _checkPermissionAfterSettings() async {
    final status = await Permission.camera.status;
    if (status.isGranted && !_hasPermission) {
      setState(() {
        _hasPermission = true;
      });
      _initializeCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });
      _initializeCamera();
    } else {
      final result = await Permission.camera.request();

      if (result.isGranted) {
        setState(() {
          _hasPermission = true;
        });
        _initializeCamera();
      } else if (result.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão necessária'),
        content: const Text(
          'É necessário permitir o uso da câmera para escanear os rótulos. '
          'Você será redirecionado para as configurações do aplicativo.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final picture = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(picture.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        _recognizedText = recognizedText.text;
      });

      textRecognizer.close();
    } catch (e) {
      setState(() {
        _recognizedText = 'Erro ao escanear o texto.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48),
                      const Text(
                        'Scanear Produto',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, size: 28),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SetupPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Aponte a câmera para a rotulagem nutricional do produto',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 4,
                        ),
                      ),
                      child: !_hasPermission
                          ? const Center(
                              child: Text(
                                'Permissão de câmera negada',
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : _controller != null &&
                                  _controller!.value.isInitialized
                              ? CameraPreview(_controller!)
                              : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _hasPermission ? _scanImage : null,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Iniciar escaneamento'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Mostra texto reconhecido
                  if (_recognizedText.isNotEmpty) ...[
                    const Text(
                      'Texto reconhecido:',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _recognizedText,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],

                  const Spacer(),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      );
                    },
                    child: const Text(
                      'Sobre',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
