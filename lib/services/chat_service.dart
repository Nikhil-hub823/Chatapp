import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a unique chat ID based on two user IDs
  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1\_$uid2' : '$uid2\_$uid1';
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
