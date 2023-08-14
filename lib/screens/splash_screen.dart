import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds:3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> HomeScreen()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Expanded(
                child: Center(
              child:
              Image.asset(
                "assets/logo.png",
                height: 150,
                width: 150,
              ),
            )),
            const Text(
              'Developed by Esraa Khlifah ',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
