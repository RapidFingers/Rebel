import 'dart:async';

import 'package:rebel_server/rebel_server_lib.dart';
import 'package:rebel_core/rebel_core_lib.dart';
import 'package:test_rebel/test_rebel_lib.dart';

/// Observes server
class ClientObserver implements AcceptObserver {
  /// On client accept
  @override
  Future<ClientListener> onAccept(Client client) async {
    return client.listen(onRequest);
  }

  /// On request
  Future<Response> onRequest(Request request) async {
    final body = request.body;
    if (body is LoginRequest) {
      print("Login: ${body.login}");
      print("Password: ${body.password}");
    } else if (body is RegisterRequest) {
      print("Login: ${body.login}");
      print("Password: ${body.email}");
      print("Age: ${body.age}");
    }
    return null;
  }
}

/// Entry point
void main() async {
  try {
    final server = new RebelServer(new ClientObserver(), new CustomBodyTransformer());
    server.debug = true;
    server.addTcpChannel(26103);
    await server.start();
  } on RebelException catch(e) {
    print(e.message);
  }
}
