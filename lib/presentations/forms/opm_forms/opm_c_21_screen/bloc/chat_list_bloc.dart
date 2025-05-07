import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class ChatListEvent {}

final class GetConversation extends ChatListEvent {
  final String userId;

  GetConversation({
    required this.userId,
  });
}

@immutable
sealed class ChatListState {}

final class ChatInitial extends ChatListState {}

final class ChatListLoading extends ChatListState {}

final class ChatListSuccess extends ChatListState {
  final List<GptInfo> conversation;

  ChatListSuccess({required this.conversation});
}

final class ChatListError extends ChatListState {
  final Object error;

  ChatListError({required this.error});
}

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final DataRepo _dataService;
  ChatListBloc(this._dataService) : super(ChatInitial()) {
    on<GetConversation>((event, emit) async {
      emit(ChatListLoading());
      try {
        var response = await _dataService.getMessages(
          userid: event.userId,
        );
        emit(ChatListSuccess(conversation: response));
      } catch (e) {
        emit(ChatListError(error: e));
      }
    });
  }
}
