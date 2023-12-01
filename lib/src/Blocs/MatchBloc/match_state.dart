part of 'match_bloc.dart';

// abstract class MatchState extends Equatable {
//   const MatchState();
  
//   @override
//   List<Object?> get props => [];
// }

// class MatchLoading extends MatchState {}

enum SearchResultFor{matched,findMe}
enum MatchStatus{ initial, loading, loaded, error}

class  MatchState{
 final List<UserMatch> matchedUsers;
 final List<UserMatch> activeMatches;
 final List<UserMatch>? searchResult;
 final bool isUserSearching;
 final List<User>? findMeResult;
 final SearchResultFor? searchResultFor;
 final MatchStatus matchStatus;
 const MatchState({ this.matchedUsers =const [],this.activeMatches=const[],this.matchStatus = MatchStatus.initial , this.searchResult=const[], this.isUserSearching = false, this.findMeResult = const [], this.searchResultFor});

 MatchState copyWith({
  List<UserMatch>? matchedUsers,
  List<UserMatch>? searchResult,
  bool? isUserSearching,
  List<User>? findMeResult,
  SearchResultFor? searchResultFor,
  MatchStatus? matchStatus,
  List<UserMatch>? activeMatches
 }){
  return MatchState(
    matchedUsers: matchedUsers??this.matchedUsers,
    searchResult: searchResult ?? this.searchResult,
    isUserSearching: isUserSearching ?? this.isUserSearching,
    findMeResult: findMeResult?? this.findMeResult,
    searchResultFor: searchResultFor?? this.searchResultFor,
    matchStatus: matchStatus?? this.matchStatus,
    activeMatches: activeMatches?? this.activeMatches
    );
 }

  @override
  // TODO: implement props
  List<Object?> get props => [matchedUsers,activeMatches, searchResult, isUserSearching, findMeResult, searchResultFor, matchStatus];
}


