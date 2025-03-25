import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_state.dart';
import '../services/chat_service.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService _chatService;

  ChatCubit(this._chatService) : super(ChatInitial());

  void loadMessages(String chatId) {
    emit(ChatLoading());

    try {
      _chatService.getMessages(chatId).listen((snapshot) {
        emit(ChatLoaded(snapshot.docs));
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      await _chatService.sendMessage(
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
