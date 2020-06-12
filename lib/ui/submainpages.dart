import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mylockeddiary/db/db_helper.dart';
import 'package:mylockeddiary/models/author.dart';
import 'package:mylockeddiary/ui/inapppage.dart';
import 'package:mylockeddiary/ui/mainpage.dart';

class SubMainPages extends StatefulWidget {
  @override
  _SubMainPagesState createState() => _SubMainPagesState();
}

class _SubMainPagesState extends State<SubMainPages> {
  String passwordIconState;
  int page;
  bool isClickAddAuthorButtonProgress;
  DbHelper dbHelper;
  List allAuthors = List<String>();
  List allAuthorsOnlyName = List<String>();
  TextEditingController newUsername = TextEditingController();
  TextEditingController newPassword1 = TextEditingController();
  TextEditingController newPassword2 = TextEditingController();
  TextEditingController selectedUserName = TextEditingController();
  String selectedUserPassword;
  int selectedUserId;
  bool passwordAreaEnabled,page2pf1Secure,page2pf2Secure,page1pfSecure;



  @override
  void dispose() {
    selectedUserName.dispose();
    newUsername.dispose();
    newPassword1.dispose();
    newPassword2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    getAllAuthors();
    page = 0;
    isClickAddAuthorButtonProgress = false;
    passwordIconState = 'null';
    passwordAreaEnabled = true;
    page1pfSecure = true;
    page2pf1Secure = true;
    page2pf2Secure = true;
  }

  // 0--mainpage // 1-Şifre girme ekranı // 2-Yeni kullanıcı ekranı//
  @override
  Widget build(BuildContext context) {
    return pageSelector();
  }

  pageSelector() {
    double size = MediaQuery.of(context).size.width / 3.5;
    if (page == 0) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (allAuthors.length >= 5) {

              Fluttertoast.showToast(
                  msg: "max 5 users",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black38,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              setState(() {
                page = 2;
              });
            }
          },
          backgroundColor: Colors.blueGrey.shade500,
          child: Icon(Icons.person_add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.transparent),
          child: ListView.builder(
              addSemanticIndexes: true,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: allAuthors.length,
              itemBuilder: (context, index) => Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      width: size,
                      height: size,
                      child: RaisedButton(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                size: size / 2,
                                color: Colors.black38,
                              ),
                              AutoSizeText(
                                allAuthors[index]['authorName'],
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                maxFontSize: 25,
                                minFontSize: 20,
                                style: TextStyle(color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        elevation: 5.0,
                        color: Colors.white70,
                        onPressed: () {
                          setState(() {
                            selectedUserId = allAuthors[index]['authorId'];
                            selectedUserName.text = allAuthors[index]['authorName'];
                            selectedUserPassword = allAuthors[index]['authorPassword'];
                            page = 1;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(size / 2)),
                        ),
                      ),
                    ),
                  )),
        ),
      );
    } else if (page == 2) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              newAuthorSaveButton(context);
            },
            backgroundColor: Colors.green.shade500,
            child: addButtonProgress(),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    page = 0;
                  });
                }),
          ),
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 7.0, // has the effect of softening the shadow
                    spreadRadius: 0, // has the effect of extending the shadow
                    offset: Offset(
                      0, // horizontal, move right 10
                      2, // vertical, move down 10
                    ),
                  )
                ],
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextField(
                    style: TextStyle(
                      fontSize: 20
                    ),
                    controller: newUsername,
                    maxLength: 12,
                    showCursor: false,
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: 'Enter New Username',
                        hintStyle: TextStyle(fontSize: 15),
                        labelText: 'Username',
                        labelStyle: TextStyle(fontSize: 19),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  TextField(
                    style: TextStyle(
                      fontSize: 20
                    ),
                    controller: newPassword1,
                    maxLength: 12,
                    obscureText: page2pf1Secure,
                    showCursor: false,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(page2pf1Secure == true ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey
                          ), 
                          onPressed: ()=>{
                          setState(() {
                            page2pf1Secure = !page2pf1Secure;
                          })
                        }),
                        counterText: '',
                        hintText: '',
                        hintStyle: TextStyle(fontSize: 15),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 19),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  TextField(
                    style: TextStyle(
                      fontSize: 20
                    ),
                    controller: newPassword2,
                    maxLength: 12,
                    obscureText: page2pf2Secure,
                    showCursor: false,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(page2pf2Secure == true ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey
                          ), 
                          onPressed: ()=>{
                          setState(() {
                            page2pf2Secure = !page2pf2Secure;
                          })
                        }),
                        counterText: '',
                        hintText: '',
                        hintStyle: TextStyle(fontSize: 15),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 19),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                ],
              )),
            ),
          ));
    } else if (page == 1) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  passwordIconState = 'null';
                  page = 0;
                });
              }),
        ),
        backgroundColor: Colors.transparent,
        body: Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 7.0, // has the effect of softening the shadow
                    spreadRadius: 0, // has the effect of extending the shadow
                    offset: Offset(
                      0, // horizontal, move right 10
                      2, // vertical, move down 10
                    ),
                  )
                ],
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextField(
                      style: TextStyle(
                      fontSize: 20
                    ),
                    controller: selectedUserName,
                    enabled: false,
                    maxLength: 12,
                    showCursor: false,
                    decoration: InputDecoration(
                        counterText: "",
                        hintStyle: TextStyle(fontSize: 15),
                        labelText: 'Username',
                        labelStyle: TextStyle(fontSize: 19),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  TextField(
                    style: TextStyle(
                      fontSize: 20
                    ),
                    enabled: passwordAreaEnabled,
                    obscureText: page1pfSecure,
                    onChanged:(t)=>{passwordTyping(t)},
                    maxLength: 12,
                    showCursor: false,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(page1pfSecure == true ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey
                          ), 
                          onPressed: ()=>{
                          setState(() {
                            page1pfSecure = !page1pfSecure;
                          })
                        }),
                      
                        counterText: "",
                        hintText: '',
                        hintStyle: TextStyle(fontSize: 16),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 20),
                        prefixIcon: passwordIconGenerator(),
                        border: OutlineInputBorder(

                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  ],
                )
                
              ),
            ),
          )
        );
      
    }
  }

  passwordTyping(String t){
    setState(() {
      passwordIconState = 'wait';
    });

    if (t == '') {
      new Timer(const Duration(milliseconds: 700), () => {
          if (t=='') {
            setState(() {
          
          passwordIconState = 'null';
        })
          }
      });

      
    }else{
      if (t != selectedUserPassword) {
        new Timer(const Duration(milliseconds: 700), () => {
          if (t != selectedUserPassword) {
            setState(() {
          
            passwordIconState = 'false';
          })
          }
      });
      }
      else{
        // şŞİFRE DOĞRU -- inAppPage sayfasına yönlendir
        new Timer(const Duration(milliseconds: 700), () => {
          if (t == selectedUserPassword) {
            setState(() {
          
              passwordIconState = 'true';
              passwordAreaEnabled = false;
              new Future.delayed(const Duration(seconds : 1),()=>{

                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => InAppPage(
                        selectedUserName.text,
                        selectedUserId
                      )),
                    )

              });
            }),

            // new Future.delayed(const Duration(seconds : 1),()=>{
            //   debugPrint("sayfa geçiş")

            // }),
          },
          
      });
      }
    }
  }


  // Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (context) => InAppPage(
  //                 selectedUserName.text
  //               )),
  //             )

  passwordIconGenerator(){
    if (passwordIconState == 'null') {
      return Icon(Icons.lock);
    }
    else if(passwordIconState == 'false'){
      return Icon(Icons.clear,color: Colors.red,);
    }else if(passwordIconState == 'wait'){
      return Padding(padding: EdgeInsets.all(10),
      child:SizedBox(
        height: 2.0,
        width: 2.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black38),
        ),
      ) ,
      
      );
    }

    else{
      return Icon(Icons.check,color: Colors.green,);
    }
  }

  itemMarginController(int index, int last) {
    if (index == 0) {
      return EdgeInsets.only(bottom: 10, left: 30, right: 10, top: 10);
    } else if (index == last - 1) {
      return EdgeInsets.only(bottom: 10, left: 10, right: 30, top: 10);
    } else {
      return EdgeInsets.all(10);
    }
  }

  newAuthorSaveButton(BuildContext context) {
    setState(() {
      isClickAddAuthorButtonProgress = true;
    });
    if (newUsername.text == "" || newPassword1.text == "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Username or Password can\'t be left blank!'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      setState(() {
                        isClickAddAuthorButtonProgress = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          });
    } else {
      if (newPassword1.text != newPassword2.text) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Passwords do not match!'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          isClickAddAuthorButtonProgress = false;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('OK')),
                ],
              );
            });
      } else {
        if (allAuthorsOnlyName.contains(newUsername.text)) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('This username has already taken!'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            isClickAddAuthorButtonProgress = false;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('OK')),
                  ],
                );
              });
        } else {
           showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Are You Sure?'),
                  content: Text('Do you want to save the new user?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            isClickAddAuthorButtonProgress = false;
                          });
                          newAuthor(newUsername.text,newPassword1.text);
                          Navigator.of(context).pop();
                          // isClickAddAuthorButtonProgress = false;
                        },
                        child: Text('OK')),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            isClickAddAuthorButtonProgress = false;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel')),
                  ],
                );
              });
          
        }
      }
    }
  }

  addButtonProgress() {
    if (isClickAddAuthorButtonProgress == false) {
      return Icon(Icons.check);
    } else {
      return CircularProgressIndicator(
        strokeWidth: 3,
        backgroundColor: Colors.black54,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  newAuthor(String authorName, String password) async {
    Author author = Author(authorName, password);
    await dbHelper.newAuthor(author).then((r) => {
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => MainPage()))
          setState(() {
            getAllAuthors();
            page = 0;
          })
        });
  }

  deleteAuthor(id) async {
    await dbHelper.deleteAuthor(id).then((r) => {
          setState(() {
            page = 0;
          })
        });
  }

  getAllAuthors() async {
    List result;
    await dbHelper.allAuthors().then((r) => {result = r});

    setState(() {
      allAuthors = result;
    });
    for (var item in allAuthors) {
      setState(() {
        allAuthorsOnlyName.add(item['authorName']);
      });
    }
  }
}

// height: MediaQuery.of(context).size.height/2.4,
//             width: MediaQuery.of(context).size.width/1.4,

// ListView.builder(

//             itemBuilder: (context, index) => Card(
//               color: Colors.red,

//               child: Center(
//                 child:Text('asd'),
//               )

//             ),
//             itemCount: allAuthors.length,
//           ),

//  Material(
//                   type: MaterialType.transparency,
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () {},
//                     splashColor: Colors.yellow,
//                     borderRadius: BorderRadius.all(
//                         Radius.circular(MediaQuery.of(context).size.width / 10)),
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.all(Radius.circular(
//                             MediaQuery.of(context).size.width / 2)),
//                         gradient:
//                             LinearGradient(colors: [Colors.red.shade300, Colors.orange.shade300,Colors.blue.shade300]),
//                       ),
//                       margin: EdgeInsets.only(left: 5,right: 5,bottom: 5, top: 10,),
//                       width: MediaQuery.of(context).size.width / 5,
//                       height: MediaQuery.of(context).size.width / 5,
//                       child: Icon(Icons.person,size: MediaQuery.of(context).size.width / (5+2),),
//                     ),
//                     Text(allAuthors[index]['authorName'],
//                       style: TextStyle(
//                         fontSize: MediaQueryData().textScaleFactor*20
//                       ),

//                     )
//                       ],
//                     )
//                   ),
//                 )

// FlatButton(

//                   onPressed: () {},
//                   color: Colors.blue.shade300,

//                   shape: RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(18.0),
//                       side: BorderSide(color: Colors.red)
//                       ),
//                   child: Column(
//                     children: <Widget>[
//                       Icon(Icons.person),
//                       Text(allAuthors[index]['authorName'])
//                     ],
//                   ),
//                 ),

// height: double.infinity,
// margin: EdgeInsets.all(10),
// color: Colors.transparent,
// child: ListView.builder(
//   padding: EdgeInsets.all(5),
//   itemBuilder: (context, index) => Align(
//     alignment: Alignment.center,
//     child: ButtonTheme(
//       minWidth: size,
//       height: size,
//       child: Container(
//         height: size,
//         child: RaisedButton(
//           onPressed: () {},
//           shape: RoundedRectangleBorder(
//               borderRadius:
//                   BorderRadius.all(Radius.circular(size / 2))),
//           padding: EdgeInsets.all(0.0),
//           child: Ink(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xff374ABE), Color(0xff64B6FF)],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius:
//                     BorderRadius.all(Radius.circular(size / 2))),
//             child: Container(
//               constraints: BoxConstraints(
//                   maxWidth: size,
//                   maxHeight: size,
//                   minHeight: size,
//                   minWidth: size),
//               alignment: Alignment.center,
//               child: Text(
//                 allAuthors[index]['authorName'],
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   ),
//   itemCount: allAuthors.length*2,
// ),
