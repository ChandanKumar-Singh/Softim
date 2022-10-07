class Attendance {
  int? id;
  String? studentId;
  String? date;
  String? isPresent;
  String? createdAt;
  String? updatedAt;

  Attendance(
      {this.id,
        this.studentId,
        this.date,
        this.isPresent,
        this.createdAt,
        this.updatedAt});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    date = json['date'];
    isPresent = json['is_present'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['date'] = this.date;
    data['is_present'] = this.isPresent;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}