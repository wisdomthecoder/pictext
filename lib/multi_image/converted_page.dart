import 'dart:io';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/route_manager.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class MultiConvertedPage extends StatefulWidget {
  List<XFile> imagesToBeConverted;
  MultiConvertedPage({required this.imagesToBeConverted, Key? key})
      : super(key: key);

  @override
  State<MultiConvertedPage> createState() => _ConvertedPageState();
}

class _ConvertedPageState extends State<MultiConvertedPage> {
  FlutterTts flutterTts = FlutterTts();
  int progress = 0;
  @override
  void initState() {
    flutterTts.setLanguage("en-US");

    flutterTts.setSpeechRate(.5);
    flutterTts.setVolume(1.0);

    flutterTts.setPitch(1.0);
    // TODO: implement initState
    super.initState();
    getRecognisedText(widget.imagesToBeConverted).then((value) {
      textScanning = false;
      print('Respect Wizzy');
    });
    textScanning = true;
  }

  bool textScanning = false;

  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController =
        TextEditingController(text: scannedText);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("PicText"),
        ),
        body: textScanning == true
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Image.asset(
                    'pictext icon.png',
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.height / 5,
                  ),
                  Text(
                    '$progress of ${widget.imagesToBeConverted.length}  Completed',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ))
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Scrollbar(
                        child: Container(
                          child: TextField(
                            expands: true,
                            style: TextStyle(fontWeight: FontWeight.w300),
                            maxLines: null,
                            minLines: null,
                            controller: editingController,
                            scrollPhysics: BouncingScrollPhysics(),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.teal,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                          onPressed: () async {
                            await FlutterClipboard.copy(editingController.text)
                                .then(
                              (value) => Get.showSnackbar(
                                GetSnackBar(
                                  duration: Duration(seconds: 2),
                                  message: 'Copied',
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            (Icons.copy),
                            size: 40,
                          ),
                          label: Text(
                            'Copy',
                            style: TextStyle(fontSize: 25),
                          )),
                      TextButton.icon(
                          onPressed: () async {
                            await flutterTts.speak(editingController.text);
                          },
                          icon: Icon(
                            (Icons.volume_up),
                            size: 40,
                          ),
                          label: Text(
                            'Read',
                            style: TextStyle(fontSize: 25),
                          ))
                    ],
                  )
                ],
              ));
  }

  Future<void> getRecognisedText(List<XFile>? images) async {
    for (XFile image in widget.imagesToBeConverted) {
      final inputImage = InputImage.fromFilePath(image.path);
      var recognisedText =
          await TextRecognizer(script: TextRecognitionScript.latin)
              .processImage(inputImage);

      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          scannedText = "$scannedText${line.text}\n";
        }
      }
      progress++;
      setState(() {});
    }
  }
}
