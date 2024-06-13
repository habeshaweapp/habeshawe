import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<String> lookignForOptions = [
      'Long-term\n partner',
      'Christian\n partner',
      'Teklil\n marriage',
      'Nikah,\n keep it halal',
      'Someone to chat, \nNew friends',
      'Still figuring it\n out',
    ];

  List<Widget> lookingForIcons =[
      const Icon(FontAwesomeIcons.heartPulse, color: Colors.red,),
      const Icon(FontAwesomeIcons.bookBible, color:Colors.black),
      const Icon(FontAwesomeIcons.crown, color: Colors.amber,),
      const Icon(Icons.diamond_outlined, color: Colors.pink,),
      Image.asset('assets/icons/goodbye.png', height: 27,width: 27,),
      Image.asset('assets/icons/rolling-eyes.png', height: 27,width: 27,)

    ];
    