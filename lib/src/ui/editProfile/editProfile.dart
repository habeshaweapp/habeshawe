import 'package:flutter/material.dart';
import 'components/body.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle( fontWeight: FontWeight.w400, fontSize: 17),),
        //backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.green,
        ),
      ),

      body: Body(),
    );
  }
}