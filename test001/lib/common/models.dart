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
	String username;
  String avatar;
  String gender;
  String birthday;

	UserData();

	UserData.fromJson(Map<String, dynamic> json) {
		password = json['password'];
		phone = json['phone'];
		username = json['username'];
    avatar=json['avatar'];
    gender=json['gender'];
    birthday=json['birthday'];
	}

	Map<String, dynamic> toJson() =>{
    'password':password,
    'phone':phone,
    'username':username,
    'avatar':avatar,
    'gender':gender,
    'birthday':birthday,

	};
}

class TestEntity {
	TestData data;
	int errorCode;
	String errorMsg;

	TestEntity({this.data, this.errorCode, this.errorMsg});

	TestEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new TestData.fromJson(json['data']) : null;
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


class TestData {
	String tPhone;
  String score;
  String testDate;
  String testType;


	TestData(this.score,this.testDate,this.testType);

	TestData.fromJson(Map<String, dynamic> json) {
		tPhone = json['tPhone'];
		score = json['score'];
    testDate=json['testDate'];
    testType=json['testType'];
	}

	Map<String, dynamic> toJson() =>{
    'tPhone':tPhone,
    'score':score,
    'testDate':testDate,
    'testType':testType,
	};
}