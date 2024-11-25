import 'dart:convert';
import 'dart:io';
import '../bin/dbHelper/mongodb.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'router/todo_router.dart';

// Configure routes.
final _router = Router(notFoundHandler: _notFoundHandler)
  ..get('/', _rootHandler)
  ..get('/api/v1/check', _checkHandler)
  ..get('/api/v1/echo/<message>', _echoHandler);

final _headers = {'Content-Type': 'application/json'};

Response _rootHandler(Request req) {
  return Response.ok(
    json.encode({'message': 'Hello,World!'}),
    headers: _headers,
  );
}

Response _checkHandler(Request req) {
  return Response.ok(
    json.encode({'message': 'Chào mừng bạn đến với web động'}),
    headers: _headers,
  );
}

Response _notFoundHandler(Request req) {
  return Response.notFound("Không tìm thấy đường dẫn'${req.url}' trên server");
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  await Mongodb.connect();
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  final corsHeader = createMiddleware(
    requestHandler: (req) {
      if (req.method == "OPTIONS") {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,PATCH,HEAD',
          'Access-Control-Allow-Headers': 'Content-Type,Authorization',
        });
      }
      return null;
    },
    responseHandler: (res) {
      return res.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,PATCH,HEAD',
        'Access-Control-Allow-Headers': 'Content-Type,Authorization',
      });
    },
  );
  final todoRouter = TodoRouter();
  _router.mount('/api/v1/', todoRouter.router.call);
  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(corsHeader)
      .addMiddleware(logRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final sever = await serve(handler, ip, port);
  print('Server đang chạy tại  http://${sever.address.host}: ${sever.port}');
}
