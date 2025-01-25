import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/addphotos.dart';

import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Data/Repository/Remote/remote_config.dart';

class Interests extends StatefulWidget {
  const Interests({super.key});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final RemoteConfigService remoteConfigService = RemoteConfigService();

  // bool _isSelected = false;
  List<String> _selectedList = [];
  //OnboardingState st;

  @override
  Widget build(BuildContext context) {
    var remoteInterests = remoteConfigService.getInterests().split(',');
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LinearProgressIndicator(value: 0.8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 35,
                    )),
              ),

              Container(
                width: 200,
                margin: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  'Intersts',
                  // textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(top: 10, left: 35),
                  child: Text(
                    'Let everyone know what you\'re passionate about \nby adding it to your profile. (${_selectedList.length}/5)',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Color.fromARGB(255, 192, 189, 189)),
                  )),
              // Spacer(flex: 1,),

              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: SizedBox(
                    //height: MediaQuery.of(context).size.height *0.67,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Wrap(
                          spacing: 5,
                          children: List.generate(
                            remoteInterests.length,
                            (index) => ChoiceChip(
                              label: Text(
                                remoteInterests[index],
                                style: TextStyle(
                                    color: _selectedList
                                            .contains(remoteInterests[index])
                                        ? isDark
                                            ? Colors.black
                                            : Colors.white
                                        : Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                              selected: _selectedList
                                  .contains(remoteInterests[index]),
                              selectedColor:
                                  isDark ? Colors.teal : Colors.green,
                              //backgroundColor: Colors.teal,
                              onSelected: (value) {
                                if (_selectedList.length < 5 ||
                                    _selectedList
                                        .contains(remoteInterests[index])) {
                                  setState(() {
                                    _selectedList
                                            .contains(remoteInterests[index])
                                        ? _selectedList
                                            .remove(remoteInterests[index])
                                        : _selectedList
                                            .add(remoteInterests[index]);
                                  });
                                }
                              },
                            ),
                          )),
                    ),
                  ),
                ),
              ),

              // Spacer(flex: 2,),
              BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  if (state is OnboardingLoaded) {
                    return Container(
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.70,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_selectedList.length > 2) {
                                context.read<OnboardingBloc>().add(UpdateUser(
                                    user: state.user
                                        .copyWith(interests: _selectedList)));
                                // GoRouter.of(context).pushNamed(MyAppRouteConstants.addphotosRouteName);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => BlocProvider.value(
                                            value:
                                                context.read<OnboardingBloc>(),
                                            child: const AddPhotos())));
                              }
                            },
                            child: Text(
                              'CONTINUE',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontSize: 17.sp, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: _selectedList.length <= 2
                                    ? Colors.grey
                                    : null),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              // const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
