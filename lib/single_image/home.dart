import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper2/image_cropper2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pictext/single_image/text_converter.dart';
// import 'package:text_recognizer/drawerData.dart';
// import 'package:text_recognizer/text_converter.dart';

class SingleImage extends StatefulWidget {
  const SingleImage({super.key});

  @override
  State<SingleImage> createState() => _HomeState();
}

class _HomeState extends State<SingleImage> {
  getFromGallery(ImageSource imageSource) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: imageSource,
    );
    if (pickedFile == null) return;
    _cropImage(pickedFile.path);
  }

  /// Crop Image
  _cropImage(filePath) async {
    var croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      // aspectRatio: CropAspectRatioPr/,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop and Edit Image',
            toolbarColor: Colors.teal,
            backgroundColor: Colors.teal.shade900,
            toolbarWidgetColor: Colors.white,
            showCropGrid: true,
            activeControlsWidgetColor: Colors.teal,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedImage != null) {
      images = croppedImage;
      setState(() {});
    }
  }

  var scannedText = "";

  CroppedFile? images;

  pickImage(ImageSource imageSource) async {}
  var isScanning = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('PicText'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // if (textScanning) const CircularProgressIndicator(),

                      images != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(
                                File(
                                  images!.path,
                                ),
                                width: double.infinity,
                              ),
                            )
                          : Text(
                              'Pick Image from:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      if ((images == null))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: width / 2.5,
                                height: 200,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.teal.shade700,
                                    onPrimary: Colors.white,
                                    shadowColor: Colors.grey[400],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                  onPressed: () {
                                    getFromGallery(ImageSource.gallery);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 50,
                                        ),
                                        Text(
                                          "Gallery",
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            Container(
                                width: width / 2.5,
                                padding: const EdgeInsets.only(top: 10),
                                height: 200,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.teal.shade500,
                                    onPrimary: Colors.white,
                                    shadowColor: Colors.grey[400],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                  onPressed: () {
                                    getFromGallery(ImageSource.camera);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 50,
                                        ),
                                        Text(
                                          "Camera",
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (!(images == null))
                        TextButton(
                            onPressed: () {
                              images = null;
                              setState(() {});
                            },
                            child: Text('Clear Image')),
                      if (!(images == null))
                        ElevatedButton(
                            onPressed: () {
                              Get.to(ConvertedPage(
                                  imageToBeConverted: XFile(images!.path)));
                            },
                            child: Text('Convert to Text'))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
