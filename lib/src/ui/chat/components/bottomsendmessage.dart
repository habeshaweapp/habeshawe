import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../Data/Models/usermatch_model.dart';

class BottomSendMessage extends StatelessWidget {
  final UserMatch userMatch;
  const BottomSendMessage(this.userMatch);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              width: MediaQuery.of(context).size.width/1.3,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.all(
                  Radius.circular(20)
                ),
              ),
              child: const TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type Here!',
                  //hintStyle: Theme.of(context).textTheme.bodySmall,
                  icon: Icon(
                    FontAwesomeIcons.faceSmile, 
                    color: Colors.grey,
                    size: 20,
                    ),
                    suffix: Icon(
                      FontAwesomeIcons.paperclip,
                      color: Colors.grey,
                      size: 20,
                    )
                ),
              ),
            ),

            SizedBox(width: 7,),

            Container(
              padding: EdgeInsets.only(right: 5),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: Icon(
                FontAwesomeIcons.paperPlane,
                color: Colors.white,
                size: 20,
              ),
            )
          ],
      
        ),
      ),
    );
  }
}