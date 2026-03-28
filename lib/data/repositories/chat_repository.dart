import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';
import '../../core/constants/app_constants.dart';

class ChatRepository {
  final _firestore = FirebaseFirestore.instance;

  /// Real-time stream of messages in a chat, ordered oldest → newest
  Stream<List<MessageModel>> watchMessages(String chatId) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((s) => s.docs.map(MessageModel.fromFirestore).toList());
  }

  /// Send a message and update chat metadata atomically
  Future<void> sendMessage(MessageModel message) async {
    final batch = _firestore.batch();

    final msgRef = _firestore
        .collection(AppConstants.chatsCollection)
        .doc(message.chatId)
        .collection(AppConstants.messagesCollection)
        .doc();
    batch.set(msgRef, message.toFirestore());

    final chatRef = _firestore
        .collection(AppConstants.chatsCollection)
        .doc(message.chatId);
    batch.update(chatRef, {
      'lastMessage': message.content,
      'lastMessageAt': Timestamp.fromDate(message.createdAt),
      'unreadCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  /// Reset unread counter when user opens the chat
  Future<void> markAsRead(String chatId) async {
    await _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .update({'unreadCount': 0});
  }

  /// Real-time stream of all chats for a user
  Stream<List<ChatModel>> watchUserChats(String userId) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ChatModel.fromFirestore).toList());
  }
}
