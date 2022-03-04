class AddDogRequest {
  String dogName;
  bool breed;
  String breedName;
  String dob;
  String gender;
  bool isVetChecked;
  bool isPedigree;
  bool isPassport;
  bool isVaccinated;
  String weight;
  String trainingNotes;

  AddDogRequest(
      this.dogName,
      this.breed,
      this.breedName,
      this.dob,
      this.gender,
      this.isVetChecked,
      this.isPedigree,
      this.isPassport,
      this.isVaccinated,
      this.weight,
      this.trainingNotes);

  Map<String, dynamic> toJson() => {
        'dogName': dogName,
        'breed': breedName,
        'breedName': breedName,
        'dob': dob,
        'gender': gender,
        'isVetChecked': isVetChecked,
        'isPedigree': isPedigree,
        'isPassport': isPassport,
        'isVaccinated': isVaccinated,
        'weight': weight,
        'trainingNotes': trainingNotes
      };
}
