import 'package:admin_sec_pro/screens/pending/pendingScreen/model/pending_model.dart';
import 'package:admin_sec_pro/screens/pending/pendingScreen/service/fetch_pending.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

part 'pending_event.dart';
part 'pending_state.dart';

class PendingBloc extends Bloc<PendingEvent, PendingState> {
  final FetchPending _fetchPending;
  StreamSubscription? _salonsSubscription;

  PendingBloc({
    required FetchPending fetchPending,
  }) : _fetchPending = fetchPending,
       super(PendingInitial()) {
    on<FetchPendingSalons>(_onFetchPendingSalons);
  }

  Future<void> _onFetchPendingSalons(
    FetchPendingSalons event,
    Emitter<PendingState> emit,
  ) async {
    emit(PendingLoading());
    
    await _salonsSubscription?.cancel();
    
    _salonsSubscription = _fetchPending.getSalons().listen(
      (salons) => emit(PendingLoaded(salons)),
      onError: (error) => emit(PendingError(error.toString())),
    );
  }

  @override
  Future<void> close() {
    _salonsSubscription?.cancel();
    return super.close();
  }
}



