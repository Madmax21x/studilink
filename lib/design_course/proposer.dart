import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/design_course/models/http.dart';
import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';
import 'package:best_flutter_ui_templates/design_course/category.dart';
import 'package:best_flutter_ui_templates/design_course/cours.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Proposer extends StatefulWidget {
  List user;

  Proposer(this.user);

  @override
  State<StatefulWidget> createState() {
    return _ProposerState();
  }
}

class _ProposerState extends State<Proposer> {
  List _user;
  var _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime date;
  String dropdownValue = "1";
  String response = "";
  var category_data = new List<Category>();
  var val = new List<Group>();
  var group = new List<Group>();

  String _hostname() {
    return 'http://studilink.online/studibase.category';
  }

  Future getCategoryData() async {
    http.Response response = await http.get(_hostname());
    debugPrint(response.body);
    setState(() {
      Iterable list = json.decode(response.body);
      category_data = list.map((model) => Category.fromJson(model)).toList();
    });
  }

  createCourse() async {
    var result = await http_post('studibase.group',{
        'category_id': dropdownValue,
        'title': titleController.text,
        'description': descriptionController.text,
        'place': lieuController.text,
        'date': date.toString(),
    });
    if(result.ok)
    {
      setState(() {
        debugPrint(response);
        response = result.data['status'];
      });
      getCours();
      return true;
    }
  }

  String _hostnameGroup() {
    return 'http://studilink.online/studibase.group';
  }

  Future getCours() async {
    http.Response response = await http.get(_hostnameGroup());
    debugPrint(response.body);
    setState(() {
      Iterable list = json.decode(response.body);
      group = list.map((model) => Group.fromJson(model)).toList();
    });
    return true;
  }

  int _getId(){
    getCours();
    for (var i = group.length-1; i > 0; i--) {
      if (group[i].category_id.toString() == dropdownValue && 
      group[i].title == titleController.text.inCaps && 
      group[i].description == descriptionController.text.inCaps &&
      group[i].place == lieuController.text.inCaps){
      print("okkkkkkkk");
      return group[i].id;
      }
      else{
        continue;
      }
    }
  return 0;
  }

  createMember() async {
    debugPrint("ici ok");
    var result = await http_post('studibase.membre',{
        'group_id': _getId(),
        'etudiant_id': _user[0].id,
    });
    debugPrint('ici pas ok');
    if(result.ok)
    {
      setState(() {
        debugPrint(response);
        response = result.data['status'];
      });
      return true;
    }
  }

  @override
  void initState() {
    getCategoryData();
    titleController.clear();
    lieuController.clear();
    descriptionController.clear();
    date = DateTime.now();
    _user = widget.user;
    super.initState();
  }

  
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        body: Container(
          color: DesignCourseAppTheme.nearlyWhite,
          child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // RECHERCHE - TITRE

                Padding(
                    padding: EdgeInsets.only(top: 50.0, left: 20.0),
                    child: Row(children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: DesignCourseAppTheme.darkerText,
                        onPressed: () {
                          moveToLastScreen();
                        },
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Propose',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.darkerText,
                              ), ),

                            Text(
                              'Un Studi-Group',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                letterSpacing: 0.2,
                                color: DesignCourseAppTheme.grey,
                              ),
                            ),
                                   
                            ],
                          ),
                        ),
                    ])),

                // 2nd element of the Listview
                Form(
                  key: _formKey,
                  child: Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                      child: Column(
                        children: <Widget>[
                          //CATEGORIE

                          Padding(
                              padding: EdgeInsets.only(
                                  top: 5.0, left: 10.0, bottom: 5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward,
                                        color: DesignCourseAppTheme.nearlyBlue),
                                    iconSize: 20,
                                    elevation: 16,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: 'WorkSans',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: DesignCourseAppTheme.nearlyBlue,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: category_data.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item.nom),
                                        value: item.id.toString(),
                                      );
                                    }).toList(),
                                  ))),

                          //TITRE DU COURS

                          Padding(
                              padding: EdgeInsets.all(0),
                              child: SizedBox(
                                  height: 70.0,
                                  child: TextFormField(
                                      autofocus: true,
                                      textCapitalization: TextCapitalization.words,
                                      keyboardType: TextInputType.text,
                                      controller: titleController,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Ce champ est obligatoire.";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        debugPrint("some title has been added");
                                      },
                                      maxLines: 1,
                                      maxLength: 20,
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
                                          borderSide: BorderSide(
                                              color: Colors.grey[100]),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[100]),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        hintText: "ex: Séries Chronologiques",
                                        hintStyle: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey[600],
                                          fontFamily: 'WorkSans',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )))),

                          //LIEU

                          Padding(
                              padding: EdgeInsets.all(0),
                              child: SizedBox(
                                  height: 70.0,
                                  child: TextFormField(
                                      autofocus: true,
                                      textCapitalization: TextCapitalization.words,
                                      controller: lieuController,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Ce champ est obligatoire.";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        debugPrint(
                                            "some thematique has been added");
                                      },
                                      maxLines: 1,
                                      maxLength: 25,
                                      decoration: InputDecoration(
                                        helperText: " ",
                                        labelText: 'Lieu',
                                        labelStyle: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'WorkSans',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[600]),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[100]),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[100]),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        hintText: "ex: Salle Info Talence",
                                        hintStyle: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey[600],
                                          fontFamily: 'WorkSans',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )))),

                          //DESCRIPTION

                          Padding(
                              padding: EdgeInsets.all(0),
                              child: SizedBox(
                                  height: 120.0,
                                  child: TextFormField(
                                      autofocus: true,
                                      textCapitalization: TextCapitalization.words,
                                      controller: descriptionController,
                                      textInputAction: TextInputAction.send,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Ce champ est obligatoire.";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        debugPrint(
                                            "some thematique has been added");
                                      },
                                      maxLines: 6,
                                      maxLength: 400,
                                      decoration: InputDecoration(
                                        helperText: " ",
                                        labelText: 'Description',
                                        alignLabelWithHint: true,
                                        labelStyle: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'WorkSans',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[600]),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[100]),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[100]),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        hintText:
                                            "Donne plus de détails sur la thématique à travailler, le lieu...",
                                        hintStyle: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey[600],
                                          fontFamily: 'WorkSans',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )))),

                          //DATE

                          Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Container(
                                height: 70.0,
                                child: Container(
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.dateAndTime,
                                    minimumDate: DateTime.now(),
                                    initialDateTime: DateTime.now(),
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      setState(() => date = newDateTime);
                                    },
                                    use24hFormat: true,
                                    minuteInterval: 1,
                                  ),
                                ),
                              )),

                          //5th element : button

                          Padding(
                            padding: EdgeInsets.only(top: 25.0, bottom: 15.0),
                            child: Expanded(
                                child: InkWell(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: DesignCourseAppTheme.nearlyBlue,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: DesignCourseAppTheme.nearlyBlue
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
                                      color: DesignCourseAppTheme.nearlyWhite,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: (){
                                
                                    if (_formKey.currentState.validate()) {
                                      setState(() async{
                                        var result =  await createCourse();
                                         if (result) {
                                           var res = await getCours();
                                           if (res){
                                            createMember();
                                            _showDialog();
                                           }
                                        }
                                      });
                                    }
                              },
                            )),
                          )
                        ],
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  void _showDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            titleTextStyle: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800],
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.w400,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            elevation: 2.0,
            title:
                new Text("Vous venez de proposer un groupe."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: Text("Proposer un autre groupe",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.teal[300],
                      fontFamily: 'JosefinSans',
                      fontWeight: FontWeight.w600,
                    )),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop(); 
                    initState();
                  });
                  
                },
              ),

              new FlatButton(
                child: Text("OK",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: DesignCourseAppTheme.grey,
                      fontFamily: 'JosefinSans',
                      fontWeight: FontWeight.w600,
                    )),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder : (context){
                    return DesignCourseHomeScreen(_user);
                  }));
                },
              )
            ],
          );
        },
      );
    }

  
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  String get allInCaps => this.toUpperCase();
}