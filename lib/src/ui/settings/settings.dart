import 'package:flutter/material.dart';
import 'package:lomi/src/ui/settings/components/body.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 17),),
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.green,
        ),
      ),

      body: Body(),
    );
  }
}