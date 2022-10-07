class CourseInfo {
  int? id;
  String? course;
  Null? duration;
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