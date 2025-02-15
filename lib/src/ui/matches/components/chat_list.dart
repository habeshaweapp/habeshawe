import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';

import '../../../Blocs/PaymentBloc/payment_bloc.dart';
import '../../../Data/Models/enums.dart';
import '../../../Data/Models/tag_helper.dart';
import '../../../Data/Repository/SharedPrefes/sharedPrefes.dart';
import 'matches_image_small.dart';

class ChatList extends StatelessWidget {
  final UserMatch match;
  final int index;
  const ChatList({super.key, required this.match, required this.index});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state==ThemeMode.dark;
    return ListTile(
      leading: 
      //MatchesImage(url: imageUrl),
      ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child:match.imageUrls.isNotEmpty? CachedNetworkImage(imageUrl: match.imageUrls[0], 
          fit: BoxFit.cover, 
          height: 50,
          width: 50,
          ):Container(
            color: Colors.grey[300],
            height: 50,
            width: 50,
        
      ),
      ),

      title: Row(
        children: [
          Text(match.name,
          style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(width: 5.w,),
          (match.verified != VerifiedStatus.notVerified.name && match.verified != VerifiedStatus.pending.name &&match.verified !=null)?
                   TagHelper.getTag(name: match.verified??'not',size: 15):const SizedBox(),
        ],
      ),
      subtitle: StreamBuilder(
    
        stream:  context.read<DatabaseRepository>().getChats(context.read<AuthBloc>().state.user!.uid, context.read<AuthBloc>().state.accountType!, match.userId),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot){
          if(snapshot.hasData && snapshot.data!.isNotEmpty){
          var lastMessage = snapshot.data?.first;
         // time = lastMessage
         var seen = SharedPrefes.getMessagesNotified();
         if(lastMessage!.senderId == match.id && (lastMessage.seen == null) && index<10){
           
           if(seen==null || !seen.contains(lastMessage.id)){
            if(SharedPrefes.getFirstLogIn()==false){

            NotificationService().showMessageReceivedNotifications(title: match.name, body: lastMessage.message, payload: 'chat', channelId: lastMessage.id);
            }
            
            seen == null? seen = [lastMessage.id]: seen.add(lastMessage.id);
            SharedPrefes.setMessagesNotified(seen);
            SharedPrefes.newMessage.add('newMessage');
            
           }
           // context.read<NotificationService>().showMessageReceivedNotifications(title: match.name, body: lastMessage.message, payload: 'chat', channelId: lastMessage.id);
          }

          if(lastMessage.senderId == match.id && (lastMessage.seen != null)){
            if(seen!=null && seen.contains(lastMessage.id)){
              seen.remove(lastMessage.id);
              SharedPrefes.setMessagesNotified(seen);

            }

          }
          return Text(
            lastMessage.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            //softWrap: true,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color:(lastMessage.senderId == match.id && (lastMessage.seen == null))?isDark?Colors.white:Colors.black:null, fontWeight: (lastMessage.senderId == match.id && (lastMessage.seen == null))?FontWeight.bold:null, fontSize: 11.sp ),
            
          );
          }
          if(snapshot.hasError){
            return  Text('');
          }else{
            return  Text('');
          }

        }
        ),
      
      // Text(lastMessage,
      //         style: Theme.of(context).textTheme.bodySmall,
      //     ),
      trailing: StreamBuilder(
        stream:  context.read<DatabaseRepository>().getChats(context.read<AuthBloc>().state.user!.uid,context.read<AuthBloc>().state.accountType!, match.userId),
       
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot){
          if(snapshot.hasData && snapshot.data!.isNotEmpty){
          var time = snapshot.data?.first.timestamp?.toDate();
          var time2 = '';
          if(time != null){
             time2 = sentTime(time);
          }
          

         // time = lastMessage
          return time != null ?Text(
            time2,
            //'${time.hour}:${time.minute}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
          ):
            Icon(Icons.access_time, size: 17,)
          ;
          }

          if(snapshot.hasError){
            return  Text('');
          }else{
            return  Text('');
          }

        }
        ),
      //Text('7:02 AM', style: Theme.of(context).textTheme.bodySmall,),
    );
  }

  String sentTime(DateTime date){
    var todaydDate = DateTime.now();
    var today = DateTime(todaydDate.year, todaydDate.month, todaydDate.day );
    var yesterday = DateTime(todaydDate.year, todaydDate.month, todaydDate.day-1 );
    //var sent = null;
    
    var sent = DateTime(date.year, date.month, date.day );
    

    if(sent == today){
      return DateFormat('hh:mm a').format(date);

    }
    else{
      int diff = todaydDate.difference(date).inDays;
      if(diff<6){
        return DateFormat.E().format(date).toString();
      }


      if(sent.year == today.year){
        return DateFormat.MMMd() .format(date);
      }
      return DateFormat('dd.MM.yy') .format(date);
    }
  }
}