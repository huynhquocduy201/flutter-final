import 'package:flutter_project/model/user_model.dart';
import 'package:localstore/localstore.dart';

class UserService {
  final db = Localstore.getInstance(useSupportDir: true);
  final path = 'user';

    Future<List<UserModel>> getAllUser() async {
    final usersMap = await db.collection(path).get();
    if (usersMap != null) {
      return usersMap.entries.map((entry) {
        final userData = entry.value as Map<String, dynamic>;
        if (!userData.containsKey('id')) {
          userData['id'] = entry.key.split('/').last;
        }
        return UserModel.fromMap(userData);
      }).toList();
    }
    return [];
  }

  Future<void> saveEvent(UserModel item) async {
    item.id ??= db.collection(path).doc().id;

    await db.collection(path).doc(item.id).set(item.toMap());
  }

  Future<void> deleteEvent(UserModel item) async {
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id).delete();
  }
}
