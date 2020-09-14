

class LoginReq {
  String phone;
  String password;

  LoginReq(this.phone, this.password);

  LoginReq.fromJson(Map<String, dynamic> json)
      : phone = json['phone'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
      };

  @override
  String toString() {
    return '{' +
        " \"phone\":\"" +
        phone +
        "\"" +
        ", \"password\":\"" +
        password +
        "\"" +
        '}';
  }
}

class RegisterReq {
  String phone;
  String password;

  RegisterReq(this.phone, this.password);

  RegisterReq.fromJson(Map<String, dynamic> json)
      : phone = json['phone'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
      };

  @override
  String toString() {
    return '{' +
        " \"phone\":\"" +
        phone +
        "\"" +
        ", \"password\":\"" +
        password +
        "\""
            '}';
  }
}

class UserModel {
  String phone;
  String password;

  UserModel.fromJson(Map<String, dynamic> json)
      : phone = json['phone'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write(",\"phone\":\"$phone\"");
    sb.write(",\"password\":\"$password\"");
    sb.write('}');
    return sb.toString();
  }
}
