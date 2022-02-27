
class AddDogRequest{

  String dogName;
  bool breed;
  String dob;
  String gender;
  bool isVetChecked;
  bool isPedigree;
  bool isPassport;
  bool isVaccinated;
  String weight;
  String trainingNotes;

  AddDogRequest(this.dogName,this.breed,this.dob,this.gender,this.isVetChecked,this.isPedigree,this.isPassport,this.isVaccinated,this.weight,this.trainingNotes);

  Map<String, dynamic> toJson() =>{
    'dogName':dogName,
    'breed':breed,
    'dob':dob,
    'gender':gender,
    'isVetChecked':isVetChecked,
    'isPedigree':isPedigree,
    'isPassport':isPassport,
    'isVaccinated':isVaccinated,
    'weight':weight,
    'trainingNotes':trainingNotes
  };

}