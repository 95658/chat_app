import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages =
  FirebaseFirestore.instance.collection(kMessagesCollections);
  List<Message> messageList = [];

  void sendMessage({required String message ,required String email}){
    try {
      messages.add(
        {kMessage: message, kCreatedAt: DateTime.now(), 'id' : email },
      );
    } on Exception catch (e) {
      // TODO
    }
  }

  void getMessage () {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messageList.clear();
      for (var doc in event.docs ){
        messageList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(
        messages: messageList,
      ));
    });
  }
}
