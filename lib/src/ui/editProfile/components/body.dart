import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/ui/editProfile/components/photoselector.dart';

import '../../../Blocs/ProfileBloc/profile_bloc.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    bool isThereChange = false;
    return SingleChildScrollView(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if(state is ProfileLoading){
            return Center(child: CircularProgressIndicator());
          }
          if(state is ProfileLoaded){
          int imagesCount = state.user.imageUrls.length;
          
          return WillPopScope(
            onWillPop: ()async {
              if(isThereChange == true){
                context.read<ProfileBloc>().add(EditUserProfile(user: state.user));
              }
              return true;
            },
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Media'),
                        Text(
                          '+40%',
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: SizedBox(
                      height: 380,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.70,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return
                                (imagesCount > index) ?
                                PhotoSelector(imageUrl: state.user.imageUrls[index],):
                                PhotoSelector(user: state.user);
                          }),
                    ),
                  ),
              
                  //SizedBox(height: 15,),
              
                   Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.70,
                    height: 40,
                    child: ElevatedButton(
                    onPressed: (){
                    //  Navigator.push(context, MaterialPageRoute(builder: ()=> Verification();))
                    }, 
                    child: Text(
                      'ADD MEDIA',
                      //style: Theme.of(context).textTheme.labelLarge,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                      ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Colors.green,
                        ),
                        
                    ),
                    
                  ),
                ),
              
                SizedBox(height: 25,),
              
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('About Me',),
                      Text('+30%', style: TextStyle(color: Colors.green),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 11,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: state.user.aboutMe ?? 'About Me',
                                          
                    ),
                    //controller: TextEditingController(text: state.user.aboutMe),
                    style: TextStyle(fontWeight: FontWeight.w300),
                 
          
                    onChanged: (text){

                      context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(aboutMe: text)));
                      isThereChange = true;
                    },
                    
                  ),
                ),
                //SizedBox(height: 10,),
          
                Container(
                  //height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
          
                  child: Text('Interests'),
          
                ),
                
                GestureDetector(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Text(state.user.interests.toString().replaceAll('[', '').replaceAll(']', ''),
                                style: TextStyle(),
                            ),
                  ),
                ),
          
                Container(
                  //height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 16, bottom: 8, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
          
                  child: Text('Relationship Goals'),
          
                ),
          
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                    child: Row(
                      children: [
                         Icon(LineIcons.eye),
                         SizedBox(width: 10,),
                         Text('Looking for'),
                         Spacer(),
                         Text('Still figuring it out...')
                  
                      ],
                    ),
                  ),
                  onTap: (){},
                ),
          
          
          
                Container(
                  //height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 16, bottom: 8, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
          
                  child: Text('Basics'),
          
                ),
          
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                    child: Row(
                      children: [
                         Icon(LineIcons.graduationCap),
                         SizedBox(width: 10,),
                         Text('Education'),
                         Spacer(),
                         Text(state.user.education == null ? 'Empty  >': state.user.education!),
                  
                      ],
                    ),
                  ),
                  onTap: (){},
                ),
          
          
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Job Title',),
                      Text('+5%', style: TextStyle(color: Colors.green),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: TextField(
                    //minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: state.user.jobTitle == null? 'Add Job Title' : state.user.jobTitle,
                    
                    ),
          
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(jobTitle: value)));
                      isThereChange = true;
                    },
                    
                  ),
                ),
          
          
          
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Company',),
                      Text('+5%', style: TextStyle(color: Colors.green),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: TextField(
                    //minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: state.user.company ?? 'Add Company'
                    
                    ),
          
                    onChanged: (value){
                      context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(company: value)));
                      isThereChange = true;
                    },
                    
                    
                  ),
                ),
          
          
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('School',),
                      Text('+5%', style: TextStyle(color: Colors.green),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: TextField(
                    //minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: state.user.school ?? 'Add School',                  
                    ),
          
                    onChanged: (value){
                      context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(school: value)));
                      isThereChange = true;
                    },
          
                    
                    
                  ),
                ),
          
          
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Living In',),
                      Text('+5%', style: TextStyle(color: Colors.green),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: TextField(
                    //minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: state.user.livingIn?? 'Add City',
                    
                    ),
                    onChanged: (value){
                      context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(livingIn: value)));
                      isThereChange = true;
                    },
                    
                  ),
                ),
                
              
              
                ],
              ),
            ),
          );
          }else{
            return Center(child: Text('something went wrong'),);
          }
        },
      ),
    );
  }
}
