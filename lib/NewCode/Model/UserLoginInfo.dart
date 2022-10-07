class UserLoginInfo {
  int? id;
  String? email;
  String? username;
  String? bid;
  String? dated;
  String? cid;
  String? name;
  String? father;
  String? gender;
  String? caste;
  String? contact;
  String? dob;
  String? qualification;
  String? address;
  String? rollno;
  String? sessionFrom;
  String? sessionTo;
  String? grade;
  String? issueDate;
  String? status;
  String? uid;
  String? image;
  Null? latitude;
  Null? longitude;
  Null? radius;
  String? createdAt;
  String? updatedAt;

  UserLoginInfo(
      {this.id,
        this.email,
        this.username,
        this.bid,
        this.dated,
        this.cid,
        this.name,
        this.father,
        this.gender,
        this.caste,
        this.contact,
        this.dob,
        this.qualification,
        this.address,
        this.rollno,
        this.sessionFrom,
        this.sessionTo,
        this.grade,
        this.issueDate,
        this.status,
        this.uid,
        this.image,
        this.latitude,
        this.longitude,
        this.radius,
        this.createdAt,
        this.updatedAt});

  UserLoginInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    bid = json['bid'];
    dated = json['dated'];
    cid = json['cid'];
    name = json['name'];
    father = json['father'];
    gender = json['gender'];
    caste = json['caste'];
    contact = json['contact'];
    dob = json['dob'];
    qualification = json['qualification'];
    address = json['address'];
    rollno = json['rollno'];
    sessionFrom = json['session_from'];
    sessionTo = json['session_to'];
    grade = json['grade'];
    issueDate = json['issue_date'];
    status = json['status'];
    uid = json['uid'];
    image = json['image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['bid'] = this.bid;
    data['dated'] = this.dated;
    data['cid'] = this.cid;
    data['name'] = this.name;
    data['father'] = this.father;
    data['gender'] = this.gender;
    data['caste'] = this.caste;
    data['contact'] = this.contact;
    data['dob'] = this.dob;
    data['qualification'] = this.qualification;
    data['address'] = this.address;
    data['rollno'] = this.rollno;
    data['session_from'] = this.sessionFrom;
    data['session_to'] = this.sessionTo;
    data['grade'] = this.grade;
    data['issue_date'] = this.issueDate;
    data['status'] = this.status;
    data['uid'] = this.uid;
    data['image'] = this.image;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radius'] = this.radius;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}