import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

import 'enums.dart';

class TagHelper{
  static Icon getTag({ required String name, double? size}){
    final Icon verifiedIcon;
    if(name == VerifiedStatus.verified.name){
              verifiedIcon =  Icon(Icons.verified, color: Colors.blue, size: size?? null);
         
            }else if(name == VerifiedStatus.queen.name){
              verifiedIcon =  Icon(LineIcons.crown, color: Colors.amber, size: size??null,);
    
            }else if(name == VerifiedStatus.princess.name){
              verifiedIcon = Icon(LineIcons.crown, color: Colors.blue, size:size );
            }else if(name == VerifiedStatus.king.name){
              verifiedIcon = Icon(LineIcons.crown, color: Colors.amber,size:size);
            }else if(name == VerifiedStatus.gentelmen.name){
              verifiedIcon = Icon(LineIcons.suitcase, color: Colors.blue, size:size);
              
            }else{
              verifiedIcon =  Icon(Icons.verified_outlined,size:size);
            }
      
      return verifiedIcon;

  }


  static List<dynamic> getLookingFor(int index){
    List<String> lookignForOpt = [
      'Long-term\n partner',
      'Long-term,\n open to short',
      'Short-term,\n open to long',
      'Someone to chat',
      'New friends',
      'Stil figuring it\n out',
    ];

    List<Icon> icons =[
      Icon(FontAwesomeIcons.heartCircleCheck, color: Color.fromARGB(255, 122, 17, 10) ),
      Icon(FontAwesomeIcons.faceGrinHearts,),
      Icon(LineIcons.glassCheers),
      //Icon(FontAwesomeIcons.comment,  size: 20,),
      Icon(Icons.chat_bubble, color: Color.fromARGB(255, 5, 72, 128),size: 20,),
      Icon(FontAwesomeIcons.hand, size: 20,),
      Icon(FontAwesomeIcons.faceRollingEyes)

    ];

    return [icons[index], lookignForOpt[index]];
  }
}