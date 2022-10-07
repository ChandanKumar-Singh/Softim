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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['batch_name'] = this.batchName;
    data['start_from'] = this.startFrom;
    data['end_at'] = this.endAt;
    data['branch_id'] = this.branchId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}