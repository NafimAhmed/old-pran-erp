import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class ChatEvent {}

final class SendMessage extends ChatEvent {
  final String userId;
  final String askText;

  SendMessage({required this.userId, required this.askText});
}

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatSuccess extends ChatState {}

final class ChatError extends ChatState {
  final Object error;

  ChatError({required this.error});
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DataService _dataService;
  ChatBloc(this._dataService) : super(ChatInitial()) {
    on<SendMessage>((event, emit) async {
      emit(ChatLoading());
      try {
        await _dataService.askAdd(userid: event.userId, askText: event.askText);
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatError(error: e));
      }
    });
  }
}
