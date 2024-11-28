import 'dart:developer';

import '../model/virtualmachine_model.dart';
import 'constant.dart';

import 'package:mongo_dart/mongo_dart.dart';

class Mongodb {
  static var db, userCollection;

  static connect() async {
    db = await Db(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getDataFilter(dynamic data) async {
    var arrData = await userCollection.find().toList();
    if (data["status"] == "No users") {
      arrData = await userCollection.find({'status': 'No users'}).toList();
    }
    if (data["status"] == "There are users") {
      arrData =
          await userCollection.find({'status': 'There are users'}).toList();
    }
    if (data['status'] == 'All') {
      arrData = await userCollection.find().toList();
    }
    return arrData;
  }

  static Future<String> insert(VirtualmachineModel data) async {
    try {
      var db = await userCollection.insertOne(data.toJson());
      if (db.isSuccess) {
        return "Data Inserted";
      } else {
        return "Not Inserted";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<void> asyncData(List<Map<String, dynamic>> data) async {
    await userCollection.remove({});
    await userCollection.insertAll(data);
  }

  static delete(VirtualmachineModel data) async {
    await userCollection.deleteOne({'id': data.id});
  }

  static Future<dynamic> finddata(VirtualmachineModel data) async {
    var datafind = await userCollection.findOne({'id': data.id});
    return datafind;
  }

  static Future<void> update(VirtualmachineModel data) async {
    var filter = where.eq('id', data.id);
    var update = modify
        .set('name', data.name)
        .set('cpu', data.cpu)
        .set('gpu', data.gpu)
        .set('ram', data.ram)
        .set('status', data.status)
        .set('price', data.price)
        .set('description', data.description);

    var response = await userCollection.updateMany(filter, update);
    inspect(response);
  }
}
