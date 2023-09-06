part of 'sharedpreference_cubit.dart';

class SharedpreferenceState extends Equatable {
  const SharedpreferenceState();

  @override
  List<Object> get props => [];
}

class SharedpreferenceInitial extends SharedpreferenceState {}

class Location extends SharedpreferenceState{
  final Position myLocation;
  const Location({required this.myLocation});
}
