class FeeModel {
  int? id;
  String? studentId;
  String? amount;
  String? notes;
  String? monthYear;
  String? createdAt;
  String? updatedAt;

  FeeModel(
      {this.id,
        this.studentId,
        this.amount,
        this.notes,
        this.monthYear,
        this.createdAt,
        this.updatedAt});

  FeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    amount = json['amount'];
    notes = json['notes'];
    monthYear = json['month_year'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}