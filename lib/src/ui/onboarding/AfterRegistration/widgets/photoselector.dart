
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';

import '../../../../Blocs/OnboardingBloc/onboarding_bloc.dart';
import '../../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../../Data/Models/user.dart';




class PhotoSelector extends StatefulWidget {
  const PhotoSelector({super.key, this.imageUrl, this.user});

  final String? imageUrl;
  final User? user;

  @override
  State<PhotoSelector> createState() => _PhotoSelectorState();
}

class _PhotoSelectorState extends State<PhotoSelector> {
   bool isPhotoSelected = false;
   File? imageFile;
  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 5),
      child: Container(
        //width: 100,
       // height: 150,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10),
          
          color: isDark ? Colors.grey[900]:
          Colors.grey[200]!.withOpacity(0.6)
        ),
        child:
        (widget.imageUrl == null) ?
        isPhotoSelected?Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(10),
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
                opacity: AlwaysStoppedAnimation(0.6),
              ),
            ),
            Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black,  )),
          )

          ],
        ) :
         Align(
          alignment:  Alignment.bottomRight,
          
          child: IconButton(
            icon: const Icon(Icons.add_circle,color: Colors.teal,),
            onPressed: () async{
              ImagePicker _picker = ImagePicker();
               XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
               //_picker.pickImage(source: ImageSource.values[ImageSource.Gall,ImageSource.CameraDevice]);
               List<XFile> images =[];
  
              if(_image==null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));

              }

              else{
                setState(() {
                  isPhotoSelected =true;
                  imageFile =File(_image!.path);
                });
                //for(var img in _image){

                final lastIndex = _image!.path.lastIndexOf(new RegExp(r'.jp'));
                final splitted = _image.path.substring(0, (lastIndex));
                final outPath = "${splitted}_out_${DateTime.now().toString().replaceAll(' ', '_')}${_image.path.substring(lastIndex)}";
                var image = await FlutterImageCompress.compressAndGetFile(_image.path, outPath, quality: 50
                );
                //images.add(image!);
                //context.read<ProfileBloc>().add(UpdateProfileImages(user: widget.user, image: image!));
                context.read<OnboardingBloc>().add(UpdateUserImages(image: image!));
              }
              
              if(_image !=null){
                print('image uploading.........');
               // StorageRepository().uploadImage(_image);
               // context.read<OnboardingBloc>().add(UpdateUserImages(image: _image));
               //context.read<ProfileBloc>().add(UpdateProfileImages(user: user, image: _image));
              }
            },
            )
          ): ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.imageUrl! ,
                  placeholder: (context, url) {
                    isPhotoSelected=false;
                    imageFile= null;
                    return
                  Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black,  )),
                    );
                  },
                  errorWidget: (context, url, error) => Icon(Icons.image_not_supported),

                  fit: BoxFit.cover,
                ),
                //Image.network(imageUrl!, fit: BoxFit.cover,),
                Positioned(
                  //alignment: Alignment.bottomRight,
                  top: -15,
                  left: -15,
                  child: IconButton(
                    onPressed: (){
                     // context.read<ProfileBloc>().add(DeletePhoto(imageUrl: widget.imageUrl!, userId: context.read<AuthBloc>().state.user!.uid, users: context.read<AuthBloc>().state.accountType!, ));
                     context.read<OnboardingBloc>().add(RemovePhoto(imageUrl: widget.imageUrl!));
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
                      
                      child: Icon(Icons.cancel, color: Colors.white,))
                    ),
                )
              ],
            )),
         
    
      ),
    );
  }
}





















// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lomi/src/Blocs/blocs.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';

// import '../../../../Data/Repository/Storage/storage_repository.dart';

// class PhotoSelector extends StatelessWidget {
//   const PhotoSelector({super.key, this.imageUrl, this.selectedImage});

//   final String? imageUrl;
//   final File? selectedImage;

//   @override
//   Widget build(BuildContext context) {

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10, right: 10),
//       child: Container(
//         //width: 100,
//        // height: 150,
//         decoration: BoxDecoration(
//           border: Border.all(width: 1),
//           borderRadius: BorderRadius.circular(10),
          
//         ),
//         child:
//         (imageUrl == null) ?

//         selectedImage !=null ?Stack(
//           fit: StackFit.expand,
//           children: [
//             ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//               child: Image.file(
//                 selectedImage!,
//                 fit: BoxFit.cover,
//                 opacity: AlwaysStoppedAnimation(0.6),
//               ),
//             ),
//             Center(
//           child: SizedBox(
//             height: 20,
//             width: 20,
//             child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black,  )),
//           )

//           ],
//         ):
//          Align(
//           alignment:  Alignment.bottomRight,
          
//           child: IconButton(
//             icon: const Icon(Icons.add_circle,color: Colors.green,),
//             onPressed: () async{
//               // ImagePicker _picker = ImagePicker();
//               //  XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
//               // //final  out = await getApplicationDocumentsDirectory();
//               // var img;
              
//               // if(_image == null) {
//               //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));

//               // }else{
//               //   final lastIndex = _image.path.lastIndexOf(new RegExp(r'.jp'));
//               //   final splitted = _image.path.substring(0, (lastIndex));
//               //   final outPath = "${splitted}_out${_image.path.substring(lastIndex)}";
//               //    img = await FlutterImageCompress.compressAndGetFile(_image.path, outPath, quality: 25
//               //   );
//               // }

//               ImagePicker _picker = ImagePicker();
//                List<XFile?> _image = await _picker.pickMultiImage();
//                //_picker.pickImage(source: ImageSource.values[ImageSource.Gall,ImageSource.CameraDevice]);
//                if(_image.length > 6){
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('maximum 6 images...')));
//                 _image = _image.sublist(0,6);

//                }
               
//                List<XFile> images =[];
  
//               if(_image.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));

//               }

//               else{
              
//                 for(var img in _image){

//                 final lastIndex = img!.path.lastIndexOf(new RegExp(r'.jp'));
//                 final splitted = img.path.substring(0, (lastIndex));
//                 final outPath = "${splitted}_out${img.path.substring(lastIndex)}";
//                 var image = await FlutterImageCompress.compressAndGetFile(img.path, outPath, quality: 50
//                 );
//                 //images.add(image!);
//                 //context.read<ProfileBloc>().add(UpdateProfileImages(user: widget.user, image: image!));
//                 context.read<OnboardingBloc>().add(UpdateUserImages(image: image!));
//               }
//               }
//               //print(img!.path);
//               if(_image !=null){
//                 print('image uploading.........');
//                // StorageRepository().uploadImage(_image);
//                 //context.read<OnboardingBloc>().add(UpdateUserImages(image: _image));
//                 context.read<OnboardingBloc>().add(ImagesSelected(images: _image));
//               }

//             },
//             )
//           ): Stack(
//             fit: StackFit.expand,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),

//                 child: Image.network(imageUrl!, fit: BoxFit.cover,)
//                 ),

//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   child: GestureDetector(
//                     onTap: (){
//                      // context.read<ProfileBloc>().add(DeletePhoto(imageUrl: widget.imageUrl!, userId: context.read<AuthBloc>().state.user!.uid, users: context.read<AuthBloc>().state.accountType!, ));
//                      context.read<OnboardingBloc>().add(RemovePhoto(imageUrl: imageUrl!));
                    
//                     }, 
//                     child: Container(
//                       width: 22,
//                       height: 22,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
                        

//                        color: Colors.black.withOpacity(0.5),
//                       ),
                      
//                       child: Icon(Icons.cancel, color: Colors.white,))
//                     ),
//                   )

//             ],
//           ),
         
    
//       ),
//     );
//   }
// }