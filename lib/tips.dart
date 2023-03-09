import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TipsAndTrick extends StatelessWidget {
  const TipsAndTrick({super.key});
  static const tips = [
    'Make sure Image is Looking Good',
    'Clean Your Phone Camera',
    'Make your Your Image is properly Cropped',
    'Converter'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tips and Trick')),
      body: ListView.builder(itemCount: tips.length,itemBuilder: (context, index) => Padding(padding: EdgeInsets.all(10), child: Text(tips[index]),),
        ),     );
  }
}

