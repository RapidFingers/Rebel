import 'package:rebel_client/rebel_client_lib.dart';
import 'package:test_rebel/test_rebel_lib.dart';

void main() async {
  final client = new RebelClientTcp("127.0.0.1", 26103, new CustomBodyTransformer());
  client.onRequest = (req) {};

  await client.connect();

  final registerResponse = await client.sendRequest(new RegisterRequest()
    ..login = "Batman"
    ..email = "batman@gmail.com"
    ..age = 36);

  final loginResponse = await client.sendRequest(new LoginRequest()
    ..login = "Superman"
    ..password = "1234");

  print(loginResponse.body);

  print(registerResponse.body);
}
