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
	String publicName;
	String icon;
	String nickname;
	bool admin;
	String phone;
	String token;
	String username;

	UserData({this.password, this.publicName,  this.icon, this.nickname, this.admin,this.phone, this.token, this.username});

	UserData.fromJson(Map<String, dynamic> json) {
		password = json['password'];
		publicName = json['publicName'];
		icon = json['icon'];
		nickname = json['nickname'];
		admin = json['admin'];
		phone = json['phone'];
		token = json['token'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['password'] = this.password;
		data['publicName'] = this.publicName;
		data['icon'] = this.icon;
		data['nickname'] = this.nickname;
		data['admin'] = this.admin;
		data['phone'] = this.phone;
		data['token'] = this.token;
		data['username'] = this.username;
		return data;
	}
}