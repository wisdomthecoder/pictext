import 'dart:io';
import 'dart:math';

import 'package:backdrop/backdrop.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/route_manager.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ConvertedPage extends StatefulWidget {
  XFile imageToBeConverted;
  ConvertedPage({required this.imageToBeConverted, Key? key}) : super(key: key);

  @override
  State<ConvertedPage> createState() => _ConvertedPageState();
}

class _ConvertedPageState extends State<ConvertedPage> {
  FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    flutterTts.setLanguage("en-US");

    flutterTts.setSpeechRate(.5);
    flutterTts.setVolume(1.0);

    flutterTts.setPitch(1.0);
    // TODO: implement initState
    super.initState();
    textScanning = true;

    getRecognisedText(XFile(widget.imageToBeConverted.path));
  }

  bool textScanning = false;

  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController =
        TextEditingController(text: scannedText);
    return BackdropScaffold(
        backLayer: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(''),
                accountEmail: Text('Awesome Image to Text Extractor')),
          ],
        ),
        appBar: AppBar(
          actions: [],
          automaticallyImplyLeading: true,
          elevation: 0,
          title: Text(""),
        ),
        frontLayer: textScanning == true
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
                    'Pictext is Converting Text. Please Wait for Few Seconds',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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
                            style: TextStyle(fontWeight: FontWeight.w300),
                            expands: true,
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
                            Icons.copy,
                            size: 50,
                          ),
                          label: Text('Copy')),
                      TextButton.icon(
                          onPressed: () async {
                            await flutterTts.speak(editingController.text);
                          },
                          icon: Icon(
                            Icons.volume_up,
                            size: 50,
                          ),
                          label: Text('Read')),
                    ],
                  )
                ],
              ));
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    var recognisedText = await TextRecognizer(
      script: TextRecognitionScript.latin,
    ).processImage(inputImage);
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }
}
