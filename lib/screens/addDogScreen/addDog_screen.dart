import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:pwd_app/models/AddDogRequest.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDogScreen extends StatefulWidget {
   AddDogScreen({Key? key}) ;

  @override
  _AddDogScreen createState() => _AddDogScreen();
}

class _AddDogScreen extends State<AddDogScreen> {

  final nameController = TextEditingController();
  String?  breedValue ;
  DateTime selectedDate = DateTime.now();
  TextEditingController dobController = TextEditingController();
  String? gender;
  String? vetChecked;
  String? pedigree;
  String? passport;
  String? vaccination;
  TextEditingController weightController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  final picker = ImagePicker();
  late  List<PickedFile> files=[];
  final imageController = TextEditingController();


  Future getImageFromSource(ImageSource source) async{
    final pickedImages;
    final cameraImage;

    if(source == ImageSource.gallery){
      pickedImages = await picker.getMultiImage(imageQuality: 100);
      setState(() {
        if(pickedImages != null){
          files.clear();
          pickedImages.forEach((element) {
            if(files.length<10)
            files.add(element);
          });
        }
        imageController.text = "Selected " + files.length.toString() + (files.length==1?" image" :" images");
      });
    }

    else{
      cameraImage = await picker.getImage(source: ImageSource.camera);
      setState(() {
        if(cameraImage != null)
          files = [cameraImage];
        imageController.text = "Selected " + files.length.toString() + (files.length==1?" image" :" images");
      });
    }

    Navigator.pop(context);

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    //final ProgressDialog pr = ProgressDialog(context);

    Future<void>  selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1900, 1,1),
          lastDate: DateTime.now()
      );
      if(picked!=null && picked!=selectedDate){
        setState(() {
          selectedDate = picked;
          print("setting date="+selectedDate.toString());
        });
      }
    }

    return SafeArea(
      child: Material(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     Get.back();
                    //   },
                    //   child: Icon(
                    //     Icons.arrow_back,
                    //     color: Colors.white.withOpacity(0.5),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Text(
                    //     "Add a Dog",
                    //     style: TextStyle(
                    //         color: Colors.white.withOpacity(0.5),
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  "Dog Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter Dog Details",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 12),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: nameController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Full Name",
                          hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4))),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    color: const Color(0xff191919),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Breed",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.4))
                        ),
                        hint: Text("Breed",style: TextStyle(color: Colors.white.withOpacity(0.4) ),),
                        icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                        style: TextStyle(color: Colors.white),
                        dropdownColor: const Color(0xff191919),
                        items: <String>['Yes', 'No'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: breedValue,
                        onChanged: (changedValue) {
                          setState(() {
                            breedValue=changedValue;
                          });
                        },
                      )
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextFormField(
                      controller:  dobController,

                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.white.withOpacity(0.4),
                              ), onPressed: () async{
                              FocusScope.of(context).requestFocus(new FocusNode());
                              await selectDate(context);
                              setState(() {
                                dobController.text = DateFormat('dd/MM/yyyy').format(selectedDate); //selectedDate!.day.toString()+"/"+selectedDate!.month.toString()+"/"+selectedDate!.year.toString();
                                print(dobController.text);
                              });

                          },),
                          border: InputBorder.none,
                          hintText: "DOB - dd/mm/yyyy",
                          hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4))),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.4))
                      ),
                      hint: Text("Gender",style: TextStyle(color: Colors.white.withOpacity(0.4) ),),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      style: TextStyle(color: Colors.white),
                      dropdownColor: const Color(0xff191919),
                      items: <String>['Male', 'Female'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: gender,
                      onChanged: (changedValue) {
                        setState(() {
                          gender=changedValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: imageController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          suffixIcon: MaterialButton(
                            onPressed: (){
                                  showDialog(context: context, builder: (BuildContext context) => new AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Text('Pick an Image source'),
                                    content: Text('Pick an Image source'),
                                    actions: <Widget>[
                                      InkWell(
                                        onTap: () async {
                                          await getImageFromSource(ImageSource.camera);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Flexible(flex: 2,child: Icon(Icons.camera_alt_rounded, color: Colors.white.withOpacity(0.5),)),
                                              Spacer(flex: 1),
                                              Flexible(flex: 2,child: Text("Camera",style: TextStyle(color: Colors.white.withOpacity(0.5)))),
                                            ],
                                          ),
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () async{
                                          await getImageFromSource(ImageSource.gallery);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Flexible(flex: 2,child: Icon(Icons.folder, color: Colors.white.withOpacity(0.5),)),
                                              Spacer(flex: 1),
                                              Flexible(flex: 2,child: Text("Gallery",style: TextStyle(color: Colors.white.withOpacity(0.5)))),
                                            ],
                                          ),
                                        ),
                                      )

                                    ],
                                  ));
                            },
                            child: Text("ADD"),
                            color: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                            minWidth: 12,
                          ),
                          border: InputBorder.none,
                          hintText: "Add Images (max 10 images)",
                          hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4))),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Vet checked",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.4))
                      ),
                      hint: Text("Vet checked",style: TextStyle(color: Colors.white.withOpacity(0.4) ),),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      style: TextStyle(color: Colors.white),
                      dropdownColor: const Color(0xff191919),
                      items: <String>['Yes', 'No'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: vetChecked,
                      onChanged: (changedValue) {
                        setState(() {
                          vetChecked=changedValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Pedigree",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.4))
                      ),
                      hint: Text("Pedigree",style: TextStyle(color: Colors.white.withOpacity(0.4) ),),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      style: TextStyle(color: Colors.white),
                      dropdownColor: const Color(0xff191919),
                      items: <String>['Yes', 'No'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: pedigree,
                      onChanged: (changedValue) {
                        setState(() {
                          pedigree=changedValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Passport",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.4))
                      ),
                      hint: Text("Passport",style: TextStyle(color: Colors.white.withOpacity(0.4) ),),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      style: TextStyle(color: Colors.white),
                      dropdownColor: const Color(0xff191919),
                      items: <String>['Yes', 'No'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: passport,
                      onChanged: (changedValue) {
                        setState(() {
                          passport=changedValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Vaccination",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.4))
                      ),
                      hint: Text("Vaccination",style: TextStyle(color: Colors.white.withOpacity(0.4) ),),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      style: TextStyle(color: Colors.white),
                      dropdownColor: const Color(0xff191919),
                      items: <String>['Yes', 'No'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: vaccination,
                      onChanged: (changedValue) {
                        setState(() {
                          vaccination=changedValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Weight (in Kgs)",
                          hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4))),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xff191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: notesController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Training Notes",
                          hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4))),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  onPressed: () async{

                    if(nameController.text==null || nameController.text.isEmpty ||
                        breedValue==null || breedValue!.isEmpty ||
                        dobController.text==null || dobController.text.isEmpty || gender==null || gender!.isEmpty ||
                        vetChecked==null || vetChecked!.isEmpty || pedigree==null || pedigree!.isEmpty ||
                        pedigree==null || pedigree!.isEmpty || passport==null || passport!.isEmpty || vaccination==null ||
                        vaccination!.isEmpty || weightController.text==null || weightController.text.isEmpty
                        || notesController==null || notesController.text.isEmpty || files ==null || files.isEmpty){
                      Fluttertoast.showToast(msg: "Please fill in all the details",
                          toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                      return;
                    }

                    // pr.style(
                    //     message: 'Adding dog.. Please wait',
                    //     borderRadius: 10.0,
                    //     backgroundColor: Colors.black,
                    //     progressWidget: CircularProgressIndicator(),
                    //     elevation: 10.0,
                    //     insetAnimCurve: Curves.easeInOut,
                    //     progress: 0.0,
                    //     maxProgress: 100.0,
                    //     progressTextStyle: TextStyle(
                    //         color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
                    //     messageTextStyle: TextStyle(
                    //         color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600)
                    // );

                    //await pr.show();

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final addDogResponse = await WebService().addDog(prefs.getString('emailid')!,AddDogRequest(nameController.text, breedValue=='Yes'?true:false, dobController.text,
                        gender!, vetChecked=='Yes'?true:false, pedigree=='Yes'?true:false, passport=='Yes'?true:false, vaccination=='Yes'?true:false, weightController.text, notesController.text),
                        prefs.getString('token')!);

                    if(addDogResponse==null || addDogResponse.status=='FAILURE' || addDogResponse.dogId==null || addDogResponse.dogId!.isEmpty){
                      //await pr.hide();
                      Fluttertoast.showToast(msg: "Your request could not be processed. Please try again later!!",
                          toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                      return;
                    }
                    for(PickedFile file in files){
                      await WebService().addDogImage(prefs.getString('emailid')!, addDogResponse, prefs.getString('token')!, file);
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                    Fluttertoast.showToast(msg: addDogResponse.reason!,
                        toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                    //await pr.hide();
                    Get.off(LandingScreen(currentIndex:0));
                  },
                  color: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
