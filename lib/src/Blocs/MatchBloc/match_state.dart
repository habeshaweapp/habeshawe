part of 'match_bloc.dart';

abstract class MatchState extends Equatable {
  const MatchState();
  
  @override
  List<Object?> get props => [];
}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState{
 final List<UserMatch> matchedUsers;
 final List<UserMatch>? searchResult;
 final bool isUserSearching;
 const MatchLoaded({required this.matchedUsers, this.searchResult, this.isUserSearching = false});

 MatchLoaded copyWith({
  List<UserMatch>? matchedUsers,
  List<UserMatch>? searchResult,
  bool? isUserSearching
 }){
  return MatchLoaded(
    matchedUsers: matchedUsers??this.matchedUsers,
    searchResult: searchResult ?? this.searchResult,
    isUserSearching: isUserSearching ?? this.isUserSearching
    );
 }

  @override
  // TODO: implement props
  List<Object?> get props => [matchedUsers, searchResult, isUserSearching];
}


