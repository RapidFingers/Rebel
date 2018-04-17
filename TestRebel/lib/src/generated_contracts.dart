part of test_rebel;

typedef SerializableBody BodyCreatorFunc();

abstract class BodyWithRequestId extends SerializableBody {
  final int requestId;
  BodyWithRequestId(this.requestId);
}

abstract class RequestBody extends BodyWithRequestId {
  RequestBody(int requestId) : super(requestId);
}

class CustomBodyTransformer extends BodyTransformer {
  static Map<int, BodyCreatorFunc> _creators = {
    LoginRequest.RequestId: LoginRequest.create,
    RegisterRequest.RequestId: RegisterRequest.create,
  };

  @override
  List<int> pack(SerializableBody body) {
    final binary = new BinaryData();
    if (body is BodyWithRequestId) {
      binary.writeUInt8(body.requestId);
    }
    binary.writeList(body.pack());
    return binary.toData();
  }

  @override
  SerializableBody unpack(List<int> data) {
    final binary = new BinaryData.fromList(data);
    final id = binary.readUInt8();
    final creator = _creators[id];
    if (creator == null) throw new RebelException("Unknown body id");
    final body = creator();
    body.unpack(binary.readList());
    return body;
  }
}

class LoginRequest extends RequestBody {
  LoginRequest() : super(RequestId);

  static const int RequestId = 1;

  String login;

  String password;

  static SerializableBody create() => new LoginRequest();
  @override
  List<int> pack() {
    final binary = new BinaryData();
    binary.writeStringWithLength(login);
    binary.writeStringWithLength(password);
    return binary.toData();
  }

  @override
  void unpack(List<int> data) {
    final binary = new BinaryData.fromList(data);
    login = binary.readStringWithLength();
    password = binary.readStringWithLength();
  }
}

class RegisterRequest extends RequestBody {
  RegisterRequest() : super(RequestId);

  static const int RequestId = 2;

  String login;

  String email;

  int age;

  static SerializableBody create() => new RegisterRequest();
  @override
  List<int> pack() {
    final binary = new BinaryData();
    binary.writeStringWithLength(login);
    binary.writeStringWithLength(email);
    binary.writeVarInt(age);
    return binary.toData();
  }

  @override
  void unpack(List<int> data) {
    final binary = new BinaryData.fromList(data);
    login = binary.readStringWithLength();
    email = binary.readStringWithLength();
    age = binary.readVarInt();
  }
}
