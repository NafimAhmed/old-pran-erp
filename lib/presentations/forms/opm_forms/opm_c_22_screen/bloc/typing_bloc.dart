import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

sealed class TypingEvent {}

class StartTyping extends TypingEvent {
  final String message;
  final bool typeAble;
  StartTyping({this.message = '', this.typeAble = false});
}

class TypingState {
  final String typedText;
  final bool completed;

  TypingState({required this.typedText, this.completed = false});

  TypingState copyWith({String? typedText, bool? completed}) {
    return TypingState(
      typedText: typedText ?? this.typedText,
      completed: completed ?? this.completed,
    );
  }
}

class TypingBloc extends Bloc<TypingEvent, TypingState> {
  Timer? _timer;
  int _currentIndex = 0;

  final DataRepo dataRepo;
  TypingBloc(this.dataRepo) : super(TypingState(typedText: "")) {
    on<StartTyping>((event, emit) async {
      if (!event.typeAble) {
        emit(state.copyWith(typedText: event.message, completed: true));
      } else {
        _currentIndex = 0;
        final fullText = event.message;

        final textStream = Stream.periodic(const Duration(milliseconds: 10), (
          _,
        ) {
          return fullText.substring(0, ++_currentIndex);
        }).take(fullText.length);

        await emit.forEach<String>(
          textStream,
          onData: (nextText) {
            if (_currentIndex == fullText.length) {
              return state.copyWith(typedText: nextText, completed: true);
            }
            return state.copyWith(typedText: nextText);
          },
        );
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
