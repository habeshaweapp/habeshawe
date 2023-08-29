import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Data/Models/user.dart';


class PhotoSelector extends StatelessWidget {
  const PhotoSelector({super.key, this.imageUrl, this.user});

  final String? imageUrl;
  final User? user;

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
        (imageUrl == null) ?
         Align(
          alignment:  Alignment.bottomRight,
          
          child: IconButton(
            icon: const Icon(Icons.add_circle,color: Colors.teal,),
            onPressed: () async{
              ImagePicker _picker = ImagePicker();
              final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
  
              if(_image == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));

              }
              if(_image !=null){
                print('image uploading.........');
               // StorageRepository().uploadImage(_image);
               // context.read<OnboardingBloc>().add(UpdateUserImages(image: _image));
               context.read<ProfileBloc>().add(UpdateProfileImages(user: user, image: _image));
              }
            },
            )
          ): ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl! ,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),

                  fit: BoxFit.cover,
                ),
                //Image.network(imageUrl!, fit: BoxFit.cover,),
                Positioned(
                  //alignment: Alignment.bottomRight,
                  bottom: -12,
                  right: -12,
                  child: IconButton(
                    onPressed: (){}, 
                    icon: Icon(Icons.add_circle, color: Colors.red,)
                    ),
                )
              ],
            )),
         
    
      ),
    );
  }
}