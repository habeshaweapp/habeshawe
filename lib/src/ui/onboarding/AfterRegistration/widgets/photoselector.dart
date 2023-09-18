import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../Data/Repository/Storage/storage_repository.dart';

class PhotoSelector extends StatelessWidget {
  const PhotoSelector({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: Container(
        //width: 100,
       // height: 150,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10),
          
        ),
        child:
        (imageUrl == null) ?
         Align(
          alignment:  Alignment.bottomRight,
          
          child: IconButton(
            icon: const Icon(Icons.add_circle,color: Colors.green,),
            onPressed: () async{
              ImagePicker _picker = ImagePicker();
               XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
              //final  out = await getApplicationDocumentsDirectory();
              var img;
              
              if(_image == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));

              }else{
                final lastIndex = _image.path.lastIndexOf(new RegExp(r'.jp'));
                final splitted = _image.path.substring(0, (lastIndex));
                final outPath = "${splitted}_out${_image.path.substring(lastIndex)}";
                 img = await FlutterImageCompress.compressAndGetFile(_image.path, outPath, quality: 25
                );
              }
              print(img!.path);
              if(_image !=null){
                print('image uploading.........');
               // StorageRepository().uploadImage(_image);
                context.read<OnboardingBloc>().add(UpdateUserImages(image: _image));
              }
            },
            )
          ): ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: Image.network(imageUrl!, fit: BoxFit.cover,)),
         
    
      ),
    );
  }
}