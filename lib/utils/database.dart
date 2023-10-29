import 'package:auth_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseService {
  FirebaseAuth auth = FirebaseAuth.instance;
  var user = FirebaseAuth.instance.currentUser;

  Future getUserDetails(String uid) async {
    var result = await database
        .child('Users')
        .child(uid)
        .get()
        .then((data) => data.value);
    return result;
  }

  Future getFirstUser() async {
    var result = await database.child('Users').get().then((data) => data.value);
    return result;
  }

  Future updateUserDetails(Map<String, dynamic> map) async {
    await database
        .child('Users')
        .child(user!.uid)
        .update(map)
        .then((_) => print('Data updated successfully'));
  }

  Future addChat(String chatid, var lastmessage) async {
    await database.child('Chats').child(chatid).set({
      'chat_id': chatid,
      'lastMessage': lastmessage,
    });
  }

  Future liked(String userId) async {
    var useruid = FirebaseAuth.instance.currentUser!.uid;
    await database
        .child('Users')
        .child(userId)
        .child('received')
        .set({useruid: true});
    await database
        .child('Users')
        .child(useruid)
        .child('liked')
        .set({userId: true});
    var result = await database
        .child('Users')
        .child(userId)
        .child('liked')
        .child(useruid)
        .get()
        .then((data) => data.value);
    if (result == true) {
      await database
          .child('Chats')
          .child(userId + useruid)
          .set({'user1': userId, 'user2': useruid, 'messages': []});
      await database
          .child('Users')
          .child(useruid)
          .child('matches')
          .set({userId: true});
      await database
          .child('Users')
          .child(userId)
          .child('matches')
          .set({useruid: true});
    }
  }

  Future getMatches() async {
    var result = await database
        .child('Users')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('matches')
        .get()
        .then((value) => value.value);
    return result;
  }

  Future getUserIdfromChat(String chatId) async {
    var result = await database
        .child('Chats')
        .child(chatId)
        .get()
        .then((value) => value.value);
    return result;
  }

  Future unliked(String userId) async {
    var useruid = FirebaseAuth.instance.currentUser!.uid;
    await database
        .child('Users')
        .child(userId)
        .child('received')
        .child(useruid)
        .remove();
    await database
        .child('Users')
        .child(useruid)
        .child('liked')
        .child(userId)
        .remove();
  }

  Future getChatsforUser() async {
    var result = await database.child('Chats').get().then((data) => data.value);
    return result;
  }
}
