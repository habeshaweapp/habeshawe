import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:full_screen_image/full_screen_image.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: 
                
                 CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ) ,
              
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: ()=> Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left:20.0, top:15),
                  child: Icon(Icons.arrow_back, color: Colors.white,),
                ),
              ),
            )
          ],
        )
        
        
        // FullScreenWidget(
        //   disposeLevel: DisposeLevel.Low,
        //   backgroundColor: Colors.black,
        //   child: Center(
      
        //       tag: "smallImage",
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(16),
        //         child: CachedNetworkImage(
        //           imageUrl: imageUrl,
        //           fit: BoxFit.cover,
        //         )
        //       ),
        //     ),
        //   ),
        // ),
      )
    );
  }
}