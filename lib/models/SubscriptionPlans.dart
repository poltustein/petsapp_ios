class SubscriptionPlans {
  List<Plans>? plans;

  SubscriptionPlans({this.plans});

  SubscriptionPlans.fromJson(Map<String, dynamic> json) {
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plans {
  String? planId;
  String? planName;
  String? planUrl;
  String? planCost;
  String? planCostString;
  List<PlanCosts>? planCosts;
  List<String>? planDescriptions;
  String? planDiscount;
  bool? isEnabled;
  bool? isActive;

  Plans(
      {this.planId,
        this.planName,
        this.planUrl,
        this.planCost,
        this.planCostString,
        this.planCosts,
        this.planDescriptions,
        this.planDiscount,
        this.isEnabled,
        this.isActive});

  Plans.fromJson(Map<String, dynamic> json) {
    planId = json['planId'];
    planName = json['planName'];
    planUrl = json['planUrl'];
    planCost = json['planCost'];
    planCostString = json['planCostString'];
    if (json['planCosts'] != null) {
      planCosts = <PlanCosts>[];
      json['planCosts'].forEach((v) {
        planCosts!.add(new PlanCosts.fromJson(v));
      });
    }
    planDescriptions = json['planDescriptions'].cast<String>();
    planDiscount = json['planDiscount'];
    isEnabled = json['isEnabled'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planId'] = this.planId;
    data['planName'] = this.planName;
    data['planUrl'] = this.planUrl;
    data['planCost'] = this.planCost;
    data['planCostString'] = this.planCostString;
    if (this.planCosts != null) {
      data['planCosts'] = this.planCosts!.map((v) => v.toJson()).toList();
    }
    data['planDescriptions'] = this.planDescriptions;
    data['planDiscount'] = this.planDiscount;
    data['isEnabled'] = this.isEnabled;
    data['isActive'] = this.isActive;
    return data;
  }
}

class PlanCosts {
  String? singlePlanId;
  String? planCost;

  PlanCosts({this.singlePlanId, this.planCost});

  PlanCosts.fromJson(Map<String, dynamic> json) {
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