import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_project/dbHelper/constant.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Mongodb {
  static var db, userCollection;
  static connect() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      db = await Db.create(MONGO_CONN_URL);
      await db.open();
      inspect(db);
      userCollection = db.collection(USER_COLLECTION);
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
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

  static delete(VirtualmachineModel data) async {
    await userCollection.deleteOne({'id': data.id});
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
