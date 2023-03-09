import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pictext/multi_image/converted_page.dart';

class MultiImagePick extends StatefulWidget {
  const MultiImagePick({super.key});

  @override
  State<MultiImagePick> createState() => _MultiImagePickState();
}

class _MultiImagePickState extends State<MultiImagePick> {
  List<XFile>? imageList = [];

  pickMultipleImage() async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isEmpty) return;
    setState(() {
      imageList?.addAll(pickedFiles);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = imageList?.removeAt(oldindex);
      imageList?.insert(newindex, items!);
    });
  }

  void sorting() {
    setState(() {
      imageList?.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Multi Image Coverter'),
        ),
        body: imageList!.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton.filled(
                    child:
                        Text(imageList!.isEmpty ? 'Pick Images' : 'Add Image'),
                    onPressed: () => pickMultipleImage(),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton.filled(
                            onPressed: () {
                              pickMultipleImage();
                            },
                            child: Text('Add Images')),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                imageList = [];
                              });
                            },
                            child: Text('Clear Image'))
                      ],
                    ),
                    Expanded(
                      child: ReorderableListView.builder(
                        itemCount: imageList!.length,
                        itemBuilder: (context, index) => Padding(
                          key: ValueKey(imageList?[index]),
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            children: [
                              Container(
                                color: Color.fromARGB(9, 34, 218, 255),
                                child: Row(children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(Scaffold(
                                        appBar: AppBar(
                                          elevation: 0,
                                          backgroundColor: Colors.black,
                                        ),
                                        backgroundColor: Colors.black,
                                        body: InteractiveViewer(
                                          child: Center(
                                            child: Image.file(
                                              File(
                                                imageList![index].path,
                                              ),
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                      ));
                                    },
                                    child: Image.file(
                                      File(
                                        imageList![index].path,
                                      ),
                                      width: 100,
                                      fit: BoxFit.cover,
                                      height: 100,
                                    ),
                                  ),

                                  // Text(imageList![index].path),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          imageList!.remove(imageList![index]);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 60,
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                              const Divider(
                                thickness: 1.5,
                                color: Colors.tealAccent,
                              ),
                            ],
                          ),
                        ),
                        shrinkWrap: true,
                        onReorder: reorderData,
                      ),
                    ),
                    if (imageList!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CupertinoButton.filled(
                          child: Text('Convert Image'),
                          onPressed: () => Get.to(
                            MultiConvertedPage(
                              imagesToBeConverted: imageList ?? [],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ));
  }
}
