import 'package:flutter/material.dart';
class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Login")),
      body: Container(child: Center(child: Text("On boarding Screen"),)),
      
    );
  }
}