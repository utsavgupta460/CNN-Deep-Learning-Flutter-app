import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:deeplearning/CatAndDog.dart';
class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: CatAndDog(),
      title: Text(
        'Deeplearning Models',
        style: TextStyle(
            fontFamily: 'Pacifico',
            color: Colors.blue,
            // fontWeight: FontWeight.bold,
            fontSize: 30),
      ),
      image: Image.asset('images/cat and dog.jpg'),
      photoSize: 180,
      backgroundColor: Colors.white,
    );
  }
}
