class StudentFeeReceiptModel {
  int? status;
  String? message;
  Datas? data;
  CoursesInfo? courseInfo;
  List<StudentCourseFees>? studentCourseFees;

  StudentFeeReceiptModel(
      {this.status,
        this.message,
        this.data,
        this.courseInfo,
        this.studentCourseFees});

  StudentFeeReceiptModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Datas.fromJson(json['data']) : null;
    courseInfo = json['course_info'] != null
        ? new CoursesInfo.fromJson(json['course_info'])
        : null;
    if (json['StudentCourseFees'] != null) {
      studentCourseFees = <StudentCourseFees>[];
      json['StudentCourseFees'].forEach((v) {
        studentCourseFees!.add(new StudentCourseFees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.courseInfo != null) {
      data['course_info'] = this.courseInfo!.toJson();
    }
    if (this.studentCourseFees != null) {
      data['StudentCourseFees'] =
          this.studentCourseFees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datas {
  int? id;
  String? studentId;
  String? amount;
  String? notes;
  String? monthYear;
  String? feetypeId;
  String? discount;
  String? createdAt;
  String? updatedAt;

  Datas(
      {this.id,
        this.studentId,
        this.amount,
        this.notes,
        this.monthYear,
        this.feetypeId,
        this.discount,
        this.createdAt,
        this.updatedAt});

  Datas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    amount = json['amount'];
    notes = json['notes'];
    monthYear = json['month_year'];
    feetypeId = json['feetype_id'];
    discount = json['discount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['amount'] = this.amount;
    data['notes'] = this.notes;
    data['month_year'] = this.monthYear;
    data['feetype_id'] = this.feetypeId;
    data['discount'] = this.discount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CoursesInfo {
  int? id;
  String? course;
  String? duration;
  String? feesType;
  String? status;
  String? createdAt;
  String? updatedAt;

  CoursesInfo(
      {this.id,
        this.course,
        this.duration,
        this.feesType,
        this.status,
        this.createdAt,
        this.updatedAt});

  CoursesInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    duration = json['duration'].toString();
    feesType = json['fees_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course'] = this.course;
    data['duration'] = this.duration;
    data['fees_type'] = this.feesType;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class StudentCourseFees {
  int? id;
  String? studentId;
  String? feeName;
  String? amount;
  String? createdAt;
  String? updatedAt;

  StudentCourseFees(
      {this.id,
        this.studentId,
        this.feeName,
        this.amount,
        this.createdAt,
        this.updatedAt});

  StudentCourseFees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    feeName = json['fee_name'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['fee_name'] = this.feeName;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}