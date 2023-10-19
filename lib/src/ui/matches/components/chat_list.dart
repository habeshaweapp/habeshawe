import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import 'matches_image_small.dart';

class ChatList extends StatelessWidget {
  final UserMatch match;
  const ChatList({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: 
      //MatchesImage(url: imageUrl),
      ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(imageUrl: match.imageUrls.isNotEmpty? match.imageUrls[0]: 'placeholder', 
          fit: BoxFit.cover, 
          height: 50,
          width: 50,
          )
      ),

      title: Text(match.name,
      style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: StreamBuilder(
    
        stream:  context.read<DatabaseRepository>().getChats(context.read<AuthBloc>().state.user!.uid, context.read<AuthBloc>().state.accountType!, match.userId),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot){
          if(snapshot.hasData){
          var lastMessage = snapshot.data?.first;
         // time = lastMessage
          return Text(
            lastMessage?.message ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            //softWrap: true,
            style: Theme.of(context).textTheme.bodySmall,
            
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
          if(snapshot.hasData){
          var time = snapshot.data?.first.timestamp?.toDate();
          var time2 = '';
          if(time != null){
             time2 = DateFormat('hh:mm a').format(time);
          }

         // time = lastMessage
          return time != null ?Text(
            time2,
            //'${time.hour}:${time.minute}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
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
}