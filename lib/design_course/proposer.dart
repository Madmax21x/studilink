import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:best_flutter_ui_templates/design_course/cours.dart';
import 'dart:convert';
import 'dart:async';



class Proposer extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _ProposerState();
  }
}

class _ProposerState extends State<Proposer>{


  var _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  
  DateTime date;
  String _day;
  String _time;
  int _memberCount = 0;
  int _likes = 0 ;
  String _imagePath = 'assets/design_course/interFace1.png';

  String dropdownValue = 'Maths';

  Future<Cours> createCourse(String category, String title, dynamic memberCount, String time, dynamic likes, String imagePath, String description, String place, String day) async {
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'category': category,
      'title': title,
      'memberCount': memberCount,
      'time': time,
      'likes': likes,
      'imagePath': imagePath,
      'description': description,
      'place': place,
      'day': day,
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Map coursMap = jsonDecode(response.body);
    return Cours.fromJson(coursMap);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
      body: Container(
        color: DesignCourseAppTheme.nearlyWhite,

        child:ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

          // RECHERCHE - TITRE

            Padding(padding: EdgeInsets.only(top:50.0, left: 20.0),
              child: Row(children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color:DesignCourseAppTheme.darkerText,
                  onPressed: (){
                    moveToLastScreen();
                  },
                ),
                 Text("Proposer",
                    
                    textAlign: TextAlign.left,
                    style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  )
             
                ),])),



            // 2nd element of the Listview
            Form(
              key: _formKey,
              child:Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right:30.0),
              child: Column(
                children: <Widget>[

                  //CATEGORIE
                  
                  Padding(
                    padding: EdgeInsets.only(top:5.0 ,left: 10.0, bottom:5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child:DropdownButton<String>(
                      
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward, 
                        color:DesignCourseAppTheme.nearlyBlue),
                      iconSize: 20,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'WorkSans',
                        fontSize: 18.0, 
                        fontWeight: FontWeight.w400,),
                      underline: Container(
                        height: 2,
                        color: DesignCourseAppTheme.nearlyBlue,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          
                        });
                      },
                      items: <String>['Maths', 'Physique', 'Chimie', 'Histoire', 'Droit']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ))

                  ),

                  //TITRE DU COURS
                  
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: SizedBox(
                      height: 70.0,
                      child: TextFormField(
                        controller: titleController,
                        validator: (String value){
                        if (value.isEmpty){
                          return "Ce champ est obligatoire.";
                        }
                        else{
                          return null;
                        }
                      },
                        onChanged: (value){
                          debugPrint("some title has been added");
                        },
                        maxLines: 1,
                        maxLength: 30,
                        decoration: InputDecoration(
                          helperText: " ",
                          labelText: 'Titre du cours',
                          labelStyle: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 15.0, 
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[100]),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[100]),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red,),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          hintText: "ex: Séries Chronologiques",
                          hintStyle: TextStyle(
                            fontSize: 15.0, 
                            color: Colors.grey[600], 
                            fontFamily: 'WorkSans',
                            fontWeight : FontWeight.w400,
                            ),

                        )

                      )
                      )

                  ),

                   //LIEU 

                  Padding(
                    padding: EdgeInsets.all(0),
                    child: SizedBox(
                      height: 70.0,
                      child: TextFormField(
                        controller: lieuController,
                        validator: (String value){
                        if (value.isEmpty){
                          return "Ce champ est obligatoire.";
                        }
                        else{
                          return null;
                        }
                      },
                        onChanged: (value){
                          debugPrint("some thematique has been added");
                        },
                        maxLines: 1,
                        maxLength: 30,
                        decoration: InputDecoration(
                          helperText: " ",
                          labelText: 'Lieu',
                          labelStyle: TextStyle(
                            fontSize: 15.0, 
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600]
                            ),
                          
                          filled: true,
                          fillColor: Colors.grey[100],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[100]),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[100]),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red,),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),

                          hintText: "ex: Salle Info Talence",
                          hintStyle: TextStyle(
                            fontSize: 15.0, 
                            color: Colors.grey[600], 
                            fontFamily: 'WorkSans',
                            fontWeight : FontWeight.w400,
                            ),

                        )

                      )
                      )

                  ),

                  //DESCRIPTION 

                  Padding(
                    padding: EdgeInsets.all(0),
                    child: SizedBox(
                      height: 120.0,
                      child: TextFormField(
                        controller: descriptionController,
                        validator: (String value){
                        if (value.isEmpty){
                          return "Ce champ est obligatoire.";
                        }
                        else{
                          return null;
                        }
                      },
                        onChanged: (value){
                          debugPrint("some thematique has been added");
                        },
                        maxLines: 6,
                        maxLength: 300,
                        decoration: InputDecoration(
                          helperText: " ",
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            fontSize: 15.0, 
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600]
                            ),
                          
                          filled: true,
                          fillColor: Colors.grey[100],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[100]),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[100]),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red,),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),

                          hintText: "Donne plus de détails sur la thématique à travailler, le lieu...",
                          hintStyle: TextStyle(
                            fontSize: 15.0, 
                            color: Colors.grey[600], 
                            fontFamily: 'WorkSans',
                            fontWeight : FontWeight.w400,
                            ),

                        )

                      )
                      )

                  ),

                //DATE

                  Padding(
                  padding: EdgeInsets.only(bottom:5.0),
                  child: Container(
                    height: 70.0,
                    
                    child: Container(child:CupertinoDatePicker(
                       
                          
                          mode: CupertinoDatePickerMode.dateAndTime,
                          
                          minimumDate: DateTime.now(),
                          initialDateTime: DateTime.now(),
                          
                          onDateTimeChanged: (DateTime newDateTime) {
                           
                              setState(() => date = newDateTime);
                              debugPrint("Date choisie : $date ");
                              _day = date.day.toString() + '/' + date.month.toString();
                              debugPrint("Date choisie : $_day ");
                              _time = date.hour.toString() + ':' + date.minute.toString();
                              debugPrint("Date choisie : $_time ");
                          },
                          
                          use24hFormat: true,
                          minuteInterval: 1,
                        ),

                      ),
                      
                  )
                  ),

                 
                 

          //5th element : button

                  Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom:15.0),
                    child:Expanded(
                      child: InkWell(child:Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: DesignCourseAppTheme.nearlyBlue,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: DesignCourseAppTheme
                                    .nearlyBlue
                                    .withOpacity(0.5),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Proposer',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 0.0,
                              color: DesignCourseAppTheme
                                  .nearlyWhite,
                            ),
                          ),
                        ),
                      ),
                      onTap:()  {
                        setState(() {
                          if (_formKey.currentState.validate()){
                           
                            createCourse(dropdownValue, titleController.text, _memberCount, _time, _likes,  _imagePath, descriptionController.text, lieuController.text, _day);
                            }
                        
                        },);},
                      )
                    ),
                  )
          
          ],
          )
          ),

        ),
        ]),

          
    ),
    ),);
    
  }

  void moveToLastScreen(){
    Navigator.pop(context);
  }
} 



 