import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

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

final class ChatSuccess extends ChatState {
  final List<GptInfo> conversation;
  ChatSuccess({this.conversation = const []});
}

final class ChatError extends ChatState {
  final Object error;

  ChatError({required this.error});
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DataRepo _dataService;
  List<GptInfo> conversation = [];
  ChatBloc(this._dataService) : super(ChatInitial()) {
    on<SendMessage>((event, emit) async {
      emit(ChatLoading());
      try {
        conversation.add(
          GptInfo(
            askText: event.askText,
            chatOwner: 'USER',
            chatTime: DateTime.now().toIso8601String(),
            creationDate: DateTime.now().toIso8601String(),
          ),
        );
        //await _dataService.askAdd(userid: event.userId, askText: event.askText);
        var headers = {'Content-Type': 'application/json'};
        var request = http.Request(
          'POST',
          Uri.parse('http://172.17.107.129:8000/chat'),
        );
        request.body = json.encode({"message": event.askText});
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var responseJson = json.decode(responseData);
          conversation.add(
            GptInfo(
              askText: responseJson['response'],
              chatOwner: 'SYSTEM',
              chatTime: DateTime.now().toIso8601String(),
              creationDate: DateTime.now().toIso8601String(),
            ),
          );
          emit(ChatSuccess(conversation: conversation));
        } else {
          throw Exception(response.reasonPhrase);
        }
      } catch (e) {
        emit(ChatError(error: e));
      }
    });
  }
}
