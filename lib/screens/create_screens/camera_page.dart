import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'create_food_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<CameraPage> createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late bool _cameraOn;

  Widget cameraWidget(context) {
    var camera = _controller.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_controller),
      ),
    );
  }

  Future<String?> _cropImage({required String imageFilePath}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFilePath);
    if (croppedImage == null) return null;
    return croppedImage.path;
  }

  @override
  void initState() {
    super.initState();

    // Init camera controller
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    // Init controller
    _initializeControllerFuture = _controller.initialize();

    _cameraOn = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x55000000),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && _cameraOn) {
            return cameraWidget(context);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // floatingActionButton:
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 10.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.show_chart,
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: FloatingActionButton(
                    backgroundColor: const Color(0xffffc0b8),
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller.takePicture();
                        if (!mounted) return;
                        String? imagePath =
                            await _cropImage(imageFilePath: image.path);
                        if (imagePath != null) {
                          setState(() {
                            _cameraOn = false;
                            _controller.dispose();
                          });
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateFoodPage(
                                imagePath: imagePath,
                              ),
                            ),
                          ).then((value) {
                            setState(() {
                              _cameraOn = true;
                              // Init camera controller
                              _controller = CameraController(
                                widget.camera,
                                ResolutionPreset.high,
                              );

                              // Init controller
                              _initializeControllerFuture = _controller.initialize();
                            });
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Icon(
                      size: 50,
                      Icons.circle,
                      color: Color(0xffff8473),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
