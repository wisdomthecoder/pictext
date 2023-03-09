import 'package:backdrop/backdrop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'multi_image/multi_pick.dart';

import 'single_image/home.dart';
import 'tips.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackdropScaffold(
        appBar: BackdropAppBar(
          title: Text("PicText"),
          centerTitle: true,
        ),
        backLayer: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(''),
                currentAccountPicture: Image.asset('pictext icon.png'),
                accountEmail: Text('Awesome Image to Text Extractor')),
            for (String i in ['About', 'Rate', 'Share', 'Report']) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    onTap: () => i == 'About'
                        ? showDialog(
                            context: context,
                            builder: (context) => AboutDialog(
                              applicationLegalese: '    ',
                              applicationIcon: Image.asset('pictext icon.png'),
                            ),
                          )
                        : Get.showSnackbar(GetSnackBar(
                            message: 'Coming Soon',
                            duration: Duration(seconds: 2),
                          )),
                    tileColor: Color.fromARGB(78, 255, 255, 255),
                    leading: Icon(
                      i == 'About'
                          ? Icons.more
                          : (i == 'Rate'
                              ? Icons.rate_review
                              : (i == 'Share' ? Icons.share : Icons.report)),
                      color: Colors.white,
                    ),
                    title: Text(
                      i,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 235, 231, 231),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            Spacer(),
            Text(
              'Powered and Created by \n Wisdom Dauda',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            ),
            Spacer(),
          ],
        ),
        frontLayer: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton.filled(
                child: Text('Convert an Image'),
                onPressed: () => Get.to(
                  () => SingleImage(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton.filled(
                  child: Text('Convert Multi-Image'),
                  onPressed: () => Get.to(() => MultiImagePick())),
            ),
          ],
        ),
      ),
    );
  }
}
