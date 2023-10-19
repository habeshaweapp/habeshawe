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
        systemNavigationBarColor: Color.fromARGB(51, 182, 180, 180),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      ),
      body: SafeArea(
        child: Center(
          child: 
            
             CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ) ,
          
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