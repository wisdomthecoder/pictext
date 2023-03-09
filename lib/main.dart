import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'choose_option.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  int seconds = 4;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PicText',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: FutureBuilder(
          future: Future.delayed(
            Duration(
              seconds: seconds,
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              seconds = 0;
              return Splash();
            } else {
              return ChoosePage();
            }
          },
        ));
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomRight,
            begin: Alignment.topLeft,
            tileMode: TileMode.repeated,
            colors: [
              Color.fromARGB(255, 1, 168, 129),
              Color.fromARGB(255, 0, 97, 87),
              Color.fromARGB(255, 0, 97, 87),
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Spacer(),
              Spacer(),
              Image.asset(
                'pictext icon.png',
                width: MediaQuery.of(context).size.width / 3,
              ),
              Text(
                'PicText',
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Text(
                'Note: This work\'s  using Machine Learning So the Result may not be as Smart as you want',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 7, 173, 173),
                    fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Text(
                'Powered By Wisdom Dauda',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
