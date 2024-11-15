import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:localstore/localstore.dart';
class VirtualmachineService {
  final db = Localstore.getInstance(useSupportDir: true);
  final path = 'virtualmachine';

    Future<List<VirtualmachineModel>> getAllUser() async {
    final virtualsMap = await db.collection(path).get();
    if (virtualsMap!= null) {
      return virtualsMap.entries.map((entry) {
        final virualData = entry.value as Map<String, dynamic>;
        if (!virualData .containsKey('id')) {
          virualData ['id'] = entry.key.split('/').last;
        }
        return VirtualmachineModel.fromMap(virualData);
      }).toList();
    }
    return [];
  }

  Future<void> saveEvent(VirtualmachineModel item) async {
    item.id ??= db.collection(path).doc().id;

    await db.collection(path).doc(item.id).set(item.toMap());
  }

  Future<void> deleteEvent(VirtualmachineModel item) async {
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id).delete();
  }

}