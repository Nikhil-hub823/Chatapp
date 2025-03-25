import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverEmail,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatCubit _chatCubit;
  final _chatService = ChatService();
  final _authService = AuthService();
  final _messageController = TextEditingController();
  late final String _chatId;

  @override
  void initState() {
    super.initState();
    _chatId = _chatService.getChatId(
        _authService.currentUser!.uid, widget.receiverId);
    _chatCubit = ChatCubit(_chatService);
    _chatCubit.loadMessages(_chatId);
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatCubit.sendMessage(
        chatId: _chatId,
        senderId: _authService.currentUser!.uid,
        receiverId: widget.receiverId,
        message: message,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.receiverEmail}")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              bloc: _chatCubit,
              builder: (context, state) {
                if (state is ChatLoading)
                  return const Center(child: CircularProgressIndicator());
                if (state is ChatLoaded) {
                  final messages = state.messages;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final data = messages[index];
                      final isMe =
                          data['senderId'] == _authService.currentUser!.uid;
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(data['message']),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                            hintText: 'Enter message...'))),
                IconButton(
                    icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          )
        ],
      ),
    );
  }
}
