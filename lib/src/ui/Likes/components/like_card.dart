import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lomi/src/Data/Models/model.dart';

class LikeCard extends StatelessWidget {
  final User user;
  const LikeCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 120,
      //margin: EdgeInsets.only(top: 8, left: 8),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(user.imageUrls[0]),
          fit: BoxFit.cover,
          ),
        borderRadius: BorderRadius.all(Radius.circular(10)),


      ),
      child: Stack(
        children: [
          Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [
                              
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0),
                              
                                
                          ],
                                
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          
                          )
                        ),
                      ),
                    ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Text('${user.name}, ${user.age}',
                    style: TextStyle(color: Colors.white),
                ),
        
              ]),
          ),
        )
      ],


      ),
    );
  }
}