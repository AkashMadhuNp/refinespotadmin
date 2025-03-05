part of 'pending_bloc.dart';

sealed class PendingState extends Equatable {
  const PendingState();
  
  @override
  List<Object> get props => [];
}

class PendingInitial extends PendingState {}

class PendingLoading extends PendingState {}

class PendingLoaded extends PendingState {
  final List<SaloonPendingModel> salons;

  const PendingLoaded(this.salons);

  @override
  List<Object> get props => [salons];
}

class PendingError extends PendingState {
  final String message;

  const PendingError(this.message);

  @override
  List<Object> get props => [message];
}

