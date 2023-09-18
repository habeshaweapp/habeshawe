import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/dataApi/interestslist.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/addphotos.dart';

import '../../../Blocs/ThemeCubit/theme_cubit.dart';

class EditInterests extends StatefulWidget {
  final List<String>? userInterests;
  const EditInterests({ this.userInterests});

  @override
  State<EditInterests> createState() => _EditInterestsState();
}

class _EditInterestsState extends State<EditInterests> {
 // bool _isSelected = false;
  List<String> _selectedList = [];
  //OnboardingState st;
  

  

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    if(widget. userInterests != null) _selectedList = widget.userInterests! ;
    return Scaffold(
      body: SafeArea(
        child:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LinearProgressIndicator(
                value: 0.8
        
              ),
             const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(LineIcons.times,size: 35,),
              ),
        
              Container(
                width: 200,
                margin: EdgeInsets.symmetric(horizontal:35),
                child: Text('Intersts',
               // textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.grey),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  margin: EdgeInsets.only(top: 10,left: 35),
                  child: Text(
                    'Let everyone know what you\'re passionate about \nby adding it to your profile.',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color.fromARGB(255, 192, 189, 189)),
                    )
                ),
             // Spacer(flex: 1,),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *0.69,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      spacing: 5,
                      children: List.generate(inter.length, (index) => 
                          ChoiceChip(
                          label: Text(inter[index],style: TextStyle(color: _selectedList.contains(inter[index])? Colors.white : Colors.black, fontSize: 12, fontWeight: FontWeight.w300),), 
                          selected: _selectedList.contains(inter[index]),
                          selectedColor: isDark? Colors.teal: Colors.green,
                          //backgroundColor: Colors.teal,
                          onSelected: (value) {
                            setState(() {
                              _selectedList.contains(inter[index]) ? _selectedList.remove(inter[index]) : _selectedList.add(inter[index]);
                            });
                          },
                          ),
                      )
                    ),
                  ),
                ),
              ),
              
        
              
             
        
        
        
              Spacer(flex: 2,),
              BlocBuilder<ProfileBloc, ProfileState>(
                
                builder: (context, state) {
                  
                  
                if (state is ProfileLoaded){
               return
                 Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.50,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: (){
                        context.read<ProfileBloc>().add(EditUserProfile(user: state.user.copyWith(interests: _selectedList) ));
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);

                        //context.read<OnboardingBloc>().add(UpdateUser(user: state.user.copyWith(interests: _selectedList)));
                       // GoRouter.of(context).pushNamed(MyAppRouteConstants.addphotosRouteName);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPhotos()));
                      }, 
                      child: Text('DONE',),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                      ),
                      
                      ),
                  ),
                );
                }
                else{return Center(child: CircularProgressIndicator(),);}
                }
              ),
        
             const SizedBox(height: 20,)
             
        
            ],
          ),
        )
      )
    );
  }
}