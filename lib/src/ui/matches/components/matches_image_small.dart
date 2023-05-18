import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MatchesImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final BoxShape shape;

  const MatchesImage({
    Key? key,
   required this.url,
    this.height = 150,
    this.width = 120,
    this.shape = BoxShape.rectangle,
});

  @override
  Widget build(BuildContext context) {
    return Container(
              height: height,
              width: width,
              margin: EdgeInsets.only(top: 8, right: 8, ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(url)
                  ),
                  borderRadius: shape == BoxShape.rectangle? BorderRadius.all(Radius.circular(10)):null,
                  border: Border.all(width: 1, color: Colors.green.withOpacity(0.3)),
                  shape: shape,

              ),
            );
  }
}