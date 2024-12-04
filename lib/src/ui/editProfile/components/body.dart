import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Data/Models/looking_for_datas.dart';
import 'package:lomi/src/ui/editProfile/components/photoselector.dart';

import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Data/Models/user.dart';
import '../../onboarding/AfterRegistration/interests.dart';
import '../../onboarding/AfterRegistration/widgets/lookingforitem.dart';
import 'editInterests.dart';

class Body extends StatelessWidget {

  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    bool isThereChange = false;
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;

    Color darkContainer = Color.fromARGB(255, 27, 27, 27);

    TextEditingController addCityController = TextEditingController();
    TextEditingController aboutMeController = TextEditingController();
    TextEditingController jobTitle = TextEditingController();
    TextEditingController companyController = TextEditingController();
    TextEditingController schoolController = TextEditingController();
    TextEditingController heightController = TextEditingController();
    return SingleChildScrollView(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if(state is ProfileLoading){
            return Container(child: Center(child: CircularProgressIndicator()));
          }
          if(state is ProfileLoaded){
          int imagesCount = state.user.imageUrls.length;
          bool isLight = context.read<ThemeCubit>().state == ThemeMode.light;
          addCityController.text = state.user.livingIn??'';
          aboutMeController.text = state.user.aboutMe??'';
          jobTitle.text = state.user.jobTitle??'';
          companyController.text = state.user.company??'';
          schoolController.text = state.user.school??'';
          heightController.text = state.user.height !=null?state.user.height.toString():'';

          return WillPopScope(
            onWillPop: ()async {
              if(isThereChange == true){
                context.read<ProfileBloc>().add(EditUserProfile(
                  user: state.user.copyWith(
                    aboutMe: aboutMeController.text==''?null:aboutMeController.text,
                    livingIn: addCityController.text==''?null:addCityController.text,
                    jobTitle: jobTitle.text == ''?null:jobTitle.text,
                    company: companyController.text==''?null:companyController.text ,
                    school: schoolController.text==''?null:schoolController.text,
                    height: heightController.text == ''?null: int.parse(heightController.text)
                    )));
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
                          style: TextStyle(color: isDark? Colors.teal: Colors.green),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: SizedBox(
                      height: 380.w,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
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
                                PhotoSelector(imageUrl: state.user.imageUrls[index],length: state.user.imageUrls.length,notblank: true,):
                                PhotoSelector(user: state.user, length: state.user.imageUrls.length,notblank:false);
                          }),
                    ),
                  ),
              
                  //SizedBox(height: 15,),
              
                //    Center(
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width*0.70,
                //     height: 40,
                //     child: ElevatedButton(
                //     onPressed: (){
                //     //  Navigator.push(context, MaterialPageRoute(builder: ()=> Verification();))
                //     }, 
                //     child: Text(
                //       'ADD MEDIA',
                //       //style: Theme.of(context).textTheme.labelLarge,
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w400
                //       ),
                //       ),
                //       style: ElevatedButton.styleFrom(
                //         shape: StadiumBorder(),
                //         //backgroundColor: Colors.green,
                //         ),
                        
                //     ),
                    
                //   ),
                // ),
              
                SizedBox(height: 25.h,),
              
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                  color: isLight ? Colors.grey[200]: darkContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('About Me',),
                      Text('+30%', style: TextStyle(color:isDark? Colors.teal: Colors.green),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 11,
                    onTapOutside: (event){
                      FocusManager.instance.primaryFocus!.unfocus();

                    },
                    decoration: InputDecoration(
                      
                      border: InputBorder.none,
                      hintText: state.user.aboutMe ?? 'About Me',
                      
                                          
                    ),
                    inputFormatters: [
                              LengthLimitingTextInputFormatter(600),
                            ],

                    //controller: TextEditingController(text: state.user.aboutMe),
                    controller: aboutMeController,
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize:12, color: Colors.grey),
                 
          
                    onChanged: (text){

                      //context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(aboutMe: text)));
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
                  color: isLight ? Colors.grey[200]: darkContainer,
                  ),
          
                  child: Text('Interests'),
          
                ),
                
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (cont) => BlocProvider.value(
                      value: context.read<ProfileBloc>(),
                      child: EditInterests(userInterests: state.user.interests.cast<String>() ,))));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Text(state.user.interests.toString().replaceAll('[', '').replaceAll(']', ''),
                                style: TextStyle(color: Colors.grey,fontSize:12,),
                            ),
                  ),
                ),
          
                Container(
                  //height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 16, bottom: 8, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[200]: darkContainer,
                  ),
          
                  child: Text('Relationship Goals'),
          
                ),
          
                InkWell(
                  child: Padding(
                    
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                    child: Row(
                     // mainAxisSize: MainAxisSize.max,
                      children: [
                         Icon(LineIcons.eye),
                         SizedBox(width: 10,),
                         Text('Looking for'),
                         Spacer(),
                         Text(lookignForOptions[state.user.lookingFor!].replaceAll('\n', ''),style: TextStyle(color: Colors.grey,fontSize:12,),)
                  
                      ],
                    ),
                  ),
                  onTap: (){
                    showLookingForSheet(context,state.user.lookingFor ?? 0, state.user);
                  },
                ),


                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[200]: darkContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Height',),
                      Text('+5%', style: TextStyle(color: isDark? Colors.teal: Colors.green),)
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
                      hintText: 'In cm', 
                      icon: Transform.rotate(angle:10,child: Icon(LineIcons.rulerVertical, size:18, color:isDark? Colors.grey: Colors.black )),
                      counterText: ''        
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    controller: heightController,
                    style: TextStyle(color: Colors.grey, fontSize:13,),
          
                    onChanged: (value){
                      //context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(height: int.parse(value) )));
                      isThereChange = true;
                    },
          
                    
                    
                  ),
                ),
          
          
          
                Container(
                  //height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 16, bottom: 8, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[200]: darkContainer,
                  ),
          
                  child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Basics'),
                      Text('+5%', style: TextStyle(color: isDark? Colors.teal: Colors.green),)
                    ],
                  ),
          
                ),
          
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                    child: Row(
                      children: [
                         Icon(LineIcons.graduationCap),
                         SizedBox(width: 10,),
                         Text('Education'),
                         Spacer(),
                         Text(state.user.education == null ? 'Empty  >': state.user.education!,
                            style: TextStyle(color: Colors.grey, fontSize:12,),
                         ),
                  
                      ],
                    ),
                  ),
                  onTap: (){
                    showEduLevel(context, state.user.education ?? '', state.user);
                  },
                ),
          
          
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[200]: darkContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Job Title',),
                      Text('+5%', style: TextStyle(color: isDark? Colors.teal: Colors.green),)
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
                    inputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                    controller: jobTitle,
                    style: TextStyle(color: Colors.grey, fontSize:13,),
          
                    onChanged: (value) {
                     // context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(jobTitle: value)));
                      isThereChange = true;
                    },
                    
                  ),
                ),
          
          
          
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[200]: darkContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Company',),
                      Text('+5%', style: TextStyle(color: isDark? Colors.teal: Colors.green),)
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
                    inputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                    style: TextStyle(color: Colors.grey, fontSize:13,),
                    controller: companyController,
          
                    onChanged: (value){
                      //context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(company: value)));
                      isThereChange = true;
                    },
                    
                    
                  ),
                ),
          
          
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[200]: darkContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('School',),
                      Text('+5%', style: TextStyle(color: isDark? Colors.teal: Colors.green),)
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
                    inputFormatters: [
                              LengthLimitingTextInputFormatter(55),
                            
                            ],
                    controller: schoolController,
                    style: TextStyle(color: Colors.grey, fontSize:13,),
          
                    onChanged: (value){
                      //context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(school: value)));
                      isThereChange = true;
                    },
          
                    
                    
                  ),
                ),
          
          
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(top: 20,bottom: 10, left: 15, right: 15),
                  
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[200]: darkContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Living In',),
                      Text('+5%', style: TextStyle(color: isDark? Colors.teal: Colors.green),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: TextField(
                    //minLines: 1,
                   // enabled: false,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: state.user.livingIn?? 'Add City',
                      
                    
                    ),
                    inputFormatters: [
                              LengthLimitingTextInputFormatter(55),
                            
                            ],
                    style: TextStyle(color: Colors.grey,fontSize:13,),
                    controller: addCityController,
                    onChanged: (value){
                      //context.read<ProfileBloc>().add(UpdateProfile(user: state.user.copyWith(livingIn: value)));
                      isThereChange = true;
                    },
                    
                  ),
                ),
                SizedBox(height: 5,)
                
              
              
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
  
  void showEduLevel(BuildContext context, String edu, User user){
    List<String> caps = ['Bachelors', 'In College', 'High School', 'PhD', 'In Grad School', 'Masters','Life'];
    int selectedIndex = caps.indexOf(edu);
    showModalBottomSheet(
      context: context, 
      builder: (ctx){
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:25.0, top: 25, bottom: 15),
                child: Row(children: [Icon(LineIcons.graduationCap), Text(' What is your education level?')],),
              ) ,
              SizedBox(
                
                child: Wrap(
                  spacing: 5,
                  children: List.generate(caps.length, (index) => 
              
                    ChoiceChip(
                      label: Text(caps[index],style: TextStyle(color: selectedIndex == index? Colors.white : Colors.black, fontSize: 12, fontWeight: FontWeight.w300)) , 
                      selected: selectedIndex == index,
                      selectedColor:  Theme.of(context).brightness == ThemeMode.dark? Colors.teal: Colors.green,
                      disabledColor: Colors.grey[300],
                      onSelected: (value) {
                        selectedIndex = index;
                        context.read<ProfileBloc>().add(EditUserProfile(user: user.copyWith(education: caps[index])));
                         Navigator.pop(context);
                      }),
                      )
                  )
                ),
              

            ],
          ),
        );
      }
      );
  }
  void showLookingForSheet(BuildContext context, int index, User user) {
    showModalBottomSheet(context: context, 
    builder: (ctx){
      bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
      int selectedIndex = index;

      return SizedBox(
        //height: MediaQuery.of(context).size.height * 0.46 ,
        height: 600.h ,
        child: Center(
          child: Column(
            children: [

              Container(
                        
                        margin: EdgeInsets.only(left:35, top: 35),
                        child: Text('Right now I\'m looking for',
                       // textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineSmall!,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35, top:10,bottom: 10),
                        child: Text(
                          'Increase compatibility by sharing yours!',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
                              ),
                      ),

              Container(
                                height: MediaQuery.of(context).size.width *0.67,
                                child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 5,
                                  children: List.generate(6, 
                                  (index) => LookingForItem(
                                    title: lookignForOptions[index], 
                                    icon:lookingForIcons[index], 
                                    isSelected: selectedIndex == index, 
                                    onTap: (){
                                      context.read<ProfileBloc>().add(EditUserProfile(user: user.copyWith(lookingFor: index)));
                                      Navigator.pop(context);
                                    }
                                    )
                                  ),
                              
                                ),
                              ),
            ],
          ),
        ),
      );
    }
    );
  }
}
