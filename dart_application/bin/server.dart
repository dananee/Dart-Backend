import 'dart:io';
// import 'dart:html';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

var html = File("lib/templates/index/index.html");
// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/about', _aboutPage)
  ..get('/search/<query|[a-z]+>', _searchQuery)
  ..get('/echo/<message>', _echoHandler);

Response _rootHandler(Request req) {
  

  return Response.ok(html.readAsStringSync(), headers: {'Content-Type': 'text/html'});
}

Response _aboutPage(Request req) => Response.ok('Page About');

Response _searchQuery(Request req) {
  final query = req.params['query'];
  return Response.ok('Search query: $query');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
