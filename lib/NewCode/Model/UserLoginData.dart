class UserLoginData {
  String? token;
  String? tokenType;
  String? expiresAt;
  Data? data;
  CourseInfo? courseInfo;
  List<BatchInfo>? batchInfo;
  BranchInfo? branchInfo;

  UserLoginData(
      {this.token,
        this.tokenType,
        this.expiresAt,
        this.data,
        this.courseInfo,
        this.batchInfo,
        this.branchInfo});

  UserLoginData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    courseInfo = json['course_info'] != null
        ? CourseInfo.fromJson(json['course_info'])
        : null;
    if (json['batch_info'] != null) {
      batchInfo = <BatchInfo>[];
      json['batch_info'].forEach((v) {
        batchInfo!.add(BatchInfo.fromJson(v));
      });
    }
    branchInfo = json['branch_info'] != null
        ? BranchInfo.fromJson(json['branch_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (courseInfo != null) {
      data['course_info'] = courseInfo!.toJson();
    }
    if (batchInfo != null) {
      data['batch_info'] = batchInfo!.map((v) => v.toJson()).toList();
    }
    if (branchInfo != null) {
      data['branch_info'] = branchInfo!.toJson();
    }
    return data;
  }
}

class Data {
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
  String? latitude;
  String? longitude;
  String? radius;
  String? createdAt;
  String? updatedAt;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['bid'] = bid;
    data['dated'] = dated;
    data['cid'] = cid;
    data['name'] = name;
    data['father'] = father;
    data['gender'] = gender;
    data['caste'] = caste;
    data['contact'] = contact;
    data['dob'] = dob;
    data['qualification'] = qualification;
    data['address'] = address;
    data['rollno'] = rollno;
    data['session_from'] = sessionFrom;
    data['session_to'] = sessionTo;
    data['grade'] = grade;
    data['issue_date'] = issueDate;
    data['status'] = status;
    data['uid'] = uid;
    data['image'] = image;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['radius'] = radius;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CourseInfo {
  int? id;
  String? course;
  String? duration;
  String? feesType;
  String? status;
  String? createdAt;
  String? updatedAt;

  CourseInfo(
      {this.id,
        this.course,
        this.duration,
        this.feesType,
        this.status,
        this.createdAt,
        this.updatedAt});

  CourseInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    duration = json['duration'];
    feesType = json['fees_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['course'] = course;
    data['duration'] = duration;
    data['fees_type'] = feesType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class BatchInfo {
  int? id;
  String? batchName;
  String? startFrom;
  String? endAt;
  String? branchId;
  String? status;
  String? createdAt;
  String? updatedAt;

  BatchInfo(
      {this.id,
        this.batchName,
        this.startFrom,
        this.endAt,
        this.branchId,
        this.status,
        this.createdAt,
        this.updatedAt});

  BatchInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    batchName = json['batch_name'];
    startFrom = json['start_from'];
    endAt = json['end_at'];
    branchId = json['branch_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['batch_name'] = batchName;
    data['start_from'] = startFrom;
    data['end_at'] = endAt;
    data['branch_id'] = branchId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class BranchInfo {
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
  String? latitude;
  String? longitude;
  String? radius;
  String? createdAt;
  String? updatedAt;

  BranchInfo(
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

  BranchInfo.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['bid'] = bid;
    data['dated'] = dated;
    data['cid'] = cid;
    data['name'] = name;
    data['father'] = father;
    data['gender'] = gender;
    data['caste'] = caste;
    data['contact'] = contact;
    data['dob'] = dob;
    data['qualification'] = qualification;
    data['address'] = address;
    data['rollno'] = rollno;
    data['session_from'] = sessionFrom;
    data['session_to'] = sessionTo;
    data['grade'] = grade;
    data['issue_date'] = issueDate;
    data['status'] = status;
    data['uid'] = uid;
    data['image'] = image;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['radius'] = radius;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}