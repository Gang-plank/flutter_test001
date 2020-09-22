class UserEntity {
	UserData data;
	int errorCode;
	String errorMsg;

	UserEntity({this.data, this.errorCode, this.errorMsg});

	UserEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
		errorCode = json['errorCode'];
		errorMsg = json['errorMsg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['errorCode'] = this.errorCode;
		data['errorMsg'] = this.errorMsg;
		return data;
	}
}

class UserData {
	String password;
	String phone;
	String token;
	String username;
  String avatar;
  String gender;
  DateTime birthday;

	UserData();

	UserData.fromJson(Map<String, dynamic> json) {
		password = json['password'];
		phone = json['phone'];
		token = json['token'];
		username = json['username'];
    avatar=json['avatar'];
    gender=json['gender'];
    birthday=json['birthday'];
	}

	Map<String, dynamic> toJson() =>{
    'password':password,
    'phone':phone,
    'token':token,
    'username':username,
    'avatar':avatar,
    'gender':gender,
    'birthday':birthday,

	};
}