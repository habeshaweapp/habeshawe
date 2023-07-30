import 'package:flutter/gestures.dart';

class CustomTapDownGestureRecognizer extends OneSequenceGestureRecognizer {
  final Function onTapDown;

  CustomTapDownGestureRecognizer({required this.onTapDown});
  
  @override
  // TODO: implement debugDescription
  String get debugDescription => 'custome tabdown';
  
  @override
  void didStopTrackingLastPointer(int pointer) {
    // TODO: implement didStopTrackingLastPointer
  }

  @override
  void addPointer(PointerEvent event){
    if(onTapDown(event.position)){
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    }else{
      stopTrackingPointer(event.pointer);
    }
  }
  
  @override
  void handleEvent(PointerEvent event) {
    if(event is PointerUpEvent){
      onTapDown(event.position);
      stopTrackingPointer(event.pointer);
    }
  }
}