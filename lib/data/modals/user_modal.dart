class UserModal {
  UserModal({
    required this.msg,
    required this.athlete,
    required this.token,
  });
  late final String msg;
  late final Athlete athlete;
  late final String token;

  UserModal.fromJson(Map<String, dynamic> json) {
    msg = json['msg']??'';
    athlete = Athlete.fromJson(json['athlete']);
    token = json['token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['athlete'] = athlete.toJson();
    _data['token'] = token;
    return _data;
  }
}

class Athlete {
  Athlete({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
    required this.gender,
    required this.birthdate,
    required this.role,
  });
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String email;
  late final String profileImageUrl;
  late final String gender;
  late final String birthdate;
  late final Role role;

  Athlete.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    email = json['email'];
    profileImageUrl = json['profileImageUrl'] ?? '';
    gender = json['gender'] ?? '';
    birthdate = json['birthdate'] ?? '';
    role = Role.fromJson(json['Role']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['email'] = email;
    _data['profileImageUrl'] = profileImageUrl;
    _data['gender'] = gender;
    _data['birthdate'] = birthdate;
    _data['Role'] = role.toJson();
    return _data;
  }
}

class Role {
  Role({
    required this.id,
    required this.role,
  });
  late final int id;
  late final String role;

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['role'] = role;
    return _data;
  }
}
