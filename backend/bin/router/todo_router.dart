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
}
