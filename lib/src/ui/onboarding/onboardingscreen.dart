import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  
   static const List<Tab> tabs = <Tab>[
    Tab(text: 'welcom' ,)
   ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, 
      child: Scaffold(
        body: Container(),
      )
      );
  }
}