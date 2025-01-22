import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class LoadingTestEvent {}

final class LoadingTest extends LoadingTestEvent {}

class LoadingTestState {
  final bool isInitial;
  final bool isLoading;
  final String loadingMessage;
  final bool isSuccess;

  const LoadingTestState({
    this.isInitial = true,
    this.isLoading = false,
    this.loadingMessage = "",
    this.isSuccess = false,
  });

  LoadingTestState copyWith({
    bool? isInitial,
    bool? isLoading,
    String? loadingMessage,
    bool? isSuccess,
  }) {
    return LoadingTestState(
      isInitial: isInitial ?? this.isInitial,
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// final class LoadingTestInitial extends LoadingTestState {}

// final class LoadingTestLoading extends LoadingTestState {
//   final String message;

//   LoadingTestLoading(this.message);
// }

class LoadingTestBloc extends Bloc<LoadingTestEvent, LoadingTestState> {
  LoadingTestBloc() : super(const LoadingTestState()) {
    on<LoadingTestEvent>((event, emit) async {
      emit(
        state.copyWith(
          isInitial: false,
          isLoading: true,
          isSuccess: false,
          loadingMessage: "Initializing data...",
        ),
      );
      await Future.delayed(const Duration(seconds: 5));

      emit(
        state.copyWith(
          loadingMessage: "Processing data...",
        ),
      );
      await Future.delayed(const Duration(seconds: 3));

      emit(
        state.copyWith(
          loadingMessage: "Finalizing data...",
        ),
      );
      await Future.delayed(
        const Duration(seconds: 2),
        () {
          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              loadingMessage: "",
            ),
          );
        },
      );
    });
  }
}
