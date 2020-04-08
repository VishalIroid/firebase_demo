class NewUser {
  String firstName;
  String lastName;
  String email;
  String uid;

  NewUser({this.firstName, this.lastName, this.email, this.uid});

  NewUser.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['uid'] = this.uid;
    return data;
  }
}
