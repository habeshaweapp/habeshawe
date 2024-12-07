import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Repository/Remote/remote_config.dart';

import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Data/Models/user.dart';

class PhotoSelector extends StatefulWidget {
  PhotoSelector(
      {super.key,
      this.imageUrl,
      this.user,
      required this.length,
      required this.notblank});

  final String? imageUrl;
  final User? user;
  final int length;
  bool notblank;

  @override
  State<PhotoSelector> createState() => _PhotoSelectorState();
}

class _PhotoSelectorState extends State<PhotoSelector> {
  bool isPhotoSelected = false;
  File? imageFile;
  RemoteConfigService remoteConfig = RemoteConfigService();

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    // isPhotoSelected = !widget.blank;
    if (isPhotoSelected && widget.notblank) {
      imageFile = null;
      isPhotoSelected = false;
    }

    if (widget.imageUrl == null) {
      if (isPhotoSelected && imageFile != null) {
        widget.notblank = true;
      }
    }

    //  {
    //   imageFile = null;
    //   isPhotoSelected = false;
    //  }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 5),
      child: Container(
        //width: 100,
        // height: 150,
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(10),
            color:
                isDark ? Colors.grey[900] : Colors.grey[200]!.withOpacity(0.6)),
        child: (widget.imageUrl == null)
            ? (isPhotoSelected && widget.notblank)
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                          opacity: const AlwaysStoppedAnimation(0.6),
                        ),
                      ),
                      const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            )),
                      )
                    ],
                  )
                : Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.teal,
                      ),
                      onPressed: () async {
                        ImagePicker picker = ImagePicker();
                        List<XFile?> image0 = await picker.pickMultiImage();
                        //_picker.pickImage(source: ImageSource.values[ImageSource.Gall,ImageSource.CameraDevice]);
                        List<XFile> images = [];

                        if (image0.isEmpty) {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected',style: TextStyle(color: Colors.white),),backgroundColor: Colors.black38,));
                        } else {
                          setState(() {
                            isPhotoSelected = true;
                            imageFile = File(image0[0]!.path);
                            widget.notblank = true;
                          });

                          if (image0.length + widget.length > 6) {
                            image0 = image0.sublist(0, 6 - widget.length);
                          }
                          for (var img in image0) {
                            bool samri = await processImage(img!.path);
                            if (samri) {
                              final lastIndex =
                                  img.path.lastIndexOf(RegExp(r'.jp'));
                              final splitted =
                                  img.path.substring(0, (lastIndex));
                              final outPath =
                                  "${splitted}_out_${DateTime.now().toString().replaceAll(' ', '_')}${img.path.substring(lastIndex)}";
                              var image =
                                  await FlutterImageCompress.compressAndGetFile(
                                      img.path, outPath,
                                      quality: 50);
                              //images.add(image!);
                              context.read<ProfileBloc>().add(
                                  UpdateProfileImages(
                                      user: widget.user, image: image!));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please use a real, clear photo of yours! your account might be banned!')));
                              setState(() {
                                isPhotoSelected = false;
                                imageFile = null;
                              });
                            }
                          }
                        }
                        print('image uploading.........');
                        // StorageRepository().uploadImage(_image);
                        // context.read<OnboardingBloc>().add(UpdateUserImages(image: _image));
                        //context.read<ProfileBloc>().add(UpdateProfileImages(user: user, image: _image));
                      },
                    ))
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.imageUrl!,
                      placeholder: (context, url) {
                        isPhotoSelected = false;
                        imageFile = null;
                        return const Center(
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              )),
                        );
                      },
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported),
                      fit: BoxFit.cover,
                    ),
                    //Image.network(imageUrl!, fit: BoxFit.cover,),
                    Positioned(
                      //alignment: Alignment.bottomRight,
                      top: -15,
                      left: -15,
                      child: IconButton(
                          onPressed: () {
                            if (widget.length > 2) {
                              context.read<ProfileBloc>().add(DeletePhoto(
                                    imageUrl: widget.imageUrl!,
                                    userId: context
                                        .read<AuthBloc>()
                                        .state
                                        .user!
                                        .uid,
                                    users: context
                                        .read<AuthBloc>()
                                        .state
                                        .accountType!,
                                  ));
                            }
                            // setState(() {
                            //   isPhotoSelected=false;
                            //   imageFile= null;
                            // });
                          },
                          icon: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ))),
                    )
                  ],
                )),
      ),
    );
  }

  Future<bool> processImage(String path) async {
//        final InputImage inputImage = InputImage.fromFilePath(path);
//        final ImageLabelerOptions options = ImageLabelerOptions();
//        final opts = FaceDetectorOptions();
//        final faceDetector = FaceDetector(options: opts);
//        final imageLabeler = ImageLabeler(options: options);

//       List<ImageLabel> labels =await imageLabeler.processImage(inputImage);
//       List<Face> faces = await faceDetector.processImage(inputImage);
//       final remote  = remoteConfig.ai();

//       if(remote['face']){
//         if(faces.isEmpty){
//           return false;
//         }
//     }

//       if(remote['screenshot'] || remote['poster']){
//       for (var label in labels) {
//         if(remote['screenshot']){
//         if(label.label == 'Screenshot'){
//          if(label.confidence >remote['screenshotConfidence']){
//           return false;
//          }
//         }
//         }
//     if(remote['poster']){
//         if(label.label == 'Poster'){
//           if(label.confidence >remote['posterConfidence']){
//           return false;
//          }
//         }
//     }

//       }
// }

    return true;
  }
}
