part of 'continuewith_cubit.dart';


enum ContinueStatus {initial, submitting, success, error}

class ContinuewithState extends Equatable {
  final ContinueStatus status;
  final auth.User? user;
  const ContinuewithState({
    required this.status,
    required this.user,
  });

  factory ContinuewithState.initial(){
    return ContinuewithState(
      status: ContinueStatus.initial,
      user: null,
    );
  }

  ContinuewithState copyWith({
    ContinueStatus? status,
    auth.User? user,
  }){
    return ContinuewithState(
      status: status ?? this.status,
      user: user ?? this.user, 
    );
  }

  @override
  List<Object?> get props => [status, user];
}


