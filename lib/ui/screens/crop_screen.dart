import 'dart:io';
import 'dart:math';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';

class CropPage extends StatelessWidget {
  final File imageFile;
  final CustomCropShape shape;
  final CustomImageCropController controller;

  const CropPage({
    super.key,
    required this.imageFile,
    required this.shape,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Recadrer l'image"),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  final image = await controller.onCropImage();
                  if (image != null) {
                    Navigator.of(context).pop(image);
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: CustomImageCrop(
                  cropController: controller,
                  image: FileImage(imageFile),
                  shape: shape,
                  ratio: shape == CustomCropShape.Ratio
                      ? Ratio(width: 16, height: 9)
                      : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(icon: const Icon(Icons.refresh), onPressed: controller.reset),
                  IconButton(icon: const Icon(Icons.zoom_in), onPressed: () => controller.addTransition(CropImageData(scale: 1.1))),
                  IconButton(icon: const Icon(Icons.zoom_out), onPressed: () => controller.addTransition(CropImageData(scale: 0.9))),
                  IconButton(icon: const Icon(Icons.rotate_right), onPressed: () => controller.addTransition(CropImageData(angle: pi / 4))),
                  IconButton(icon: const Icon(Icons.rotate_left), onPressed: () => controller.addTransition(CropImageData(angle: -pi / 4))),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        )
    );
  }
}