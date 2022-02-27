class MyDogsResponse {
  String? status;
  String? reason;
  List<Dogs>? dogs;
  late int total;

  MyDogsResponse({this.status, this.reason, this.dogs, required this.total});

  MyDogsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reason = json['reason'];
    total = json['total'];
    if (json['dogs'] != null) {
      dogs = <Dogs>[];
      json['dogs'].forEach((v) {
        dogs!.add(new Dogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['reason'] = this.reason;
    data['total'] = this.total;
    if (this.dogs != null) {
      data['dogs'] = this.dogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dogs {
  String? dogId;
  String? ownerId;
  String? dogName;
  String? weight;
  String? trainingNotes;
  bool? breed;
  String? dob;
  String? gender;
  List<String>? dogImages;
  bool? isVetChecked;
  bool? isPedigree;
  bool? isPassport;
  bool? isVaccinated;

  Dogs(
      {this.dogId,
        this.ownerId,
        this.dogName,
        this.weight,
        this.trainingNotes,
        this.breed,
        this.dob,
        this.gender,
        this.dogImages,
        this.isVetChecked,
        this.isPedigree,
        this.isPassport,
        this.isVaccinated});

  Dogs.fromJson(Map<String, dynamic> json) {
    dogId = json['dogId'];
    ownerId = json['ownerId'];
    dogName = json['dogName'];
    weight = json['weight'];
    trainingNotes = json['trainingNotes'];
    breed = json['breed'];
    dob = json['dob'];
    gender = json['gender'];
    dogImages = json['dogImages'].cast<String>();
    isVetChecked = json['isVetChecked'];
    isPedigree = json['isPedigree'];
    isPassport = json['isPassport'];
    isVaccinated = json['isVaccinated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dogId'] = this.dogId;
    data['ownerId'] = this.ownerId;
    data['dogName'] = this.dogName;
    data['weight'] = this.weight;
    data['trainingNotes'] = this.trainingNotes;
    data['breed'] = this.breed;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['dogImages'] = this.dogImages;
    data['isVetChecked'] = this.isVetChecked;
    data['isPedigree'] = this.isPedigree;
    data['isPassport'] = this.isPassport;
    data['isVaccinated'] = this.isVaccinated;
    return data;
  }
}