class SinglePlan {
  String? singlePlanId;
  String? planCost;

  SinglePlan({this.singlePlanId, this.planCost});

  SinglePlan.fromJson(Map<String, dynamic> json) {
    singlePlanId = json['singlePlanId'];
    planCost = json['planCost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['singlePlanId'] = this.singlePlanId;
    data['planCost'] = this.planCost;
    return data;
  }
}