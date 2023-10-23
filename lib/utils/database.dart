import 'package:auth_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseService {
  FirebaseAuth auth = FirebaseAuth.instance;
  var user = FirebaseAuth.instance.currentUser;

  Future getUserDetails(String uid) async {
    print(uid);
    var result = await database
        .child('Users')
        .child(uid)
        .get()
        .then((data) => data.value);
    print(result);
    return result;
  }

  Future updateUserDetails(Map<String, dynamic> map) async {
    await database
        .child('Users')
        .child(user!.uid)
        .update(map)
        .then((_) => print('Data updated successfully'));
  }
}
