import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../dbHelper/mongodb.dart';
import '../model/virtualmachine_model.dart';

class TodoRouter {
  final _headers = {'Content-Type': 'application/json'};
  // Tạo danh sách công việc
  //bằng cách khời tạo danh sách có kiểu dữ liệu  là TodoModel
  //final _todo = <VirtualmachineModel>[];
  Router get router {
    final router = Router();
    router.get('/todos', getVirtualMachines);
    router.post('/todos', addVirtualMachines);
    router.put('/todos', updateVirtualMachines);
    router.delete('/todos', deleteVirtualMachines);
    router.post('/todos/async', asyncData);
    router.post('/todos/finddata', findData);
    return router;
  }

  Future<Response> getVirtualMachines(Request req) async {
    try {
      final body = json.encode(await Mongodb.getData());
      return Response.ok(
        body,
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'lỗi': e.toString()}),
        headers: _headers,
      );
    }
  }

  Future<Response> addVirtualMachines(Request req) async {
    try {
      final payload = await req.readAsString();

      final data = VirtualmachineModel.fromJsonofMap(payload);
      await Mongodb.insert(data);
      return Response.ok(
        data.toJsonofMap(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'lỗi': e.toString()}),
        headers: _headers,
      );
    }
  }

  Future<Response> updateVirtualMachines(Request req) async {
    try {
      final payload = await req.readAsString();

      final data = VirtualmachineModel.fromJsonofMap(payload);
      await Mongodb.update(data);
      return Response.ok(
        data.toJsonofMap(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'lỗi': e.toString()}),
        headers: _headers,
      );
    }
  }

  Future<Response> deleteVirtualMachines(Request req) async {
    try {
      final payload = await req.readAsString();

      final data = VirtualmachineModel.fromJsonofMap(payload);
      await Mongodb.delete(data);
      return Response.ok(
        data.toJsonofMap(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'lỗi': e.toString()}),
        headers: _headers,
      );
    }
  }

  Future<Response> findData(Request req) async {
    try {
      final payload = await req.readAsString();
       final data = json.decode(payload) as List<dynamic>;
      Map<String, dynamic>   map = data.map((item) {
        return item as Map<String, dynamic>;
      }).first;
      final data1 = VirtualmachineModel.fromMap(map);
      final body = json.encode(await Mongodb.finddata(data1));
      return Response.ok(
        body,
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'lỗi': e.toString()}),
        headers: _headers,
      );
    }
  }

  Future<Response> asyncData(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = json.decode(payload) as List<dynamic>;
      List<Map<String, dynamic>> mapList = data.map((item) {
        return item as Map<String, dynamic>;
      }).toList();
      await Mongodb.asyncData(mapList);
      final body = json.encode(await Mongodb.getData());
      return Response.ok(
        body,
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'lỗi': e.toString()}),
        headers: _headers,
      );
    }
  }
}
