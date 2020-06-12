import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mylockeddiary/db/db_helper.dart';
import 'package:mylockeddiary/models/diary.dart';
import 'package:mylockeddiary/ui/mainpage.dart';
import 'package:table_calendar/table_calendar.dart';

class SubInAppPages extends StatefulWidget {
  String userName;
  int userId;

  SubInAppPages(this.userName, this.userId);

  @override
  _SubInAppPagesState createState() => _SubInAppPagesState();
}

class _SubInAppPagesState extends State<SubInAppPages> {
  Map<DateTime, List> _events;
  List allDiaries = List<String>();
  List diaryDates = List<String>();
  DbHelper dbHelper;
  bool hasDataDates = false;
  bool hasDataDiaries = false;
  int page;
  int tabIndex;
  TextEditingController newDiaryTitle = TextEditingController();
  TextEditingController newDiaryContent = TextEditingController();
  String selectedDiaryTitle, selectedDiaryContent;
  int selectedDiaryDate;
  bool page1pf2Secure,page1pf1Secure;
  TextEditingController newPassword = TextEditingController();
  TextEditingController newPassword2 = TextEditingController();
  CalendarController _calendarController;
  String calendarViewTitleDate,selectedDateDb;
  bool calendarWeekFormat,thanCalendar;

   @override
  void dispose() {
    newDiaryTitle.dispose();
    newDiaryContent.dispose();
    newPassword.dispose();
    newPassword2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    page = 0; // 0 --> all diaries // 1 --> profile page // 2 --> add diary page // 3 --> content page
    tabIndex = 0;
    dbHelper = DbHelper();
    getDiariesWithDate(widget.userId);
    getAllDiaries(widget.userId);
    selectedDiaryContent = '';
    selectedDiaryTitle = '';
    selectedDiaryDate = 0;
    
    page1pf1Secure = true;
    page1pf2Secure =true;

    _calendarController = CalendarController();
    calendarViewTitleDate = '';
    selectedDateDb = '';
    calendarWeekFormat = false;
    thanCalendar = false;
    
    _events = {
      DateTime(2020,05,05) : ['asd','!'],
      DateTime(2020,05,05).add(Duration(microseconds: 2)) : ['qwe'],

    };
    
  }

  @override
  Widget build(BuildContext context) {
    calculateEvents();
    return pageSelector();
  }


  calculateEvents() async {
    _events = {};
    for (var item in diaryDates) {
      List a = item['diaryDate'].toString().split('');
      int year = int.parse('${a[0]}${a[1]}${a[2]}${a[3]}');
      int month = int.parse('${a[4]}${a[5]}');
      int day = int.parse('${a[6]}${a[7]}');
      setState(() {
        _events[DateTime(year,month,day)] = ['event'];
      });

    }
  }


  pageSelector() {
    if (page == 0) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: tabIndex == 0 ? FloatingActionButton(
          onPressed: () => {
            setState(() {
              page = 2;
            }),
          },
          backgroundColor: Colors.blueGrey.shade500,
          child: Icon(Icons.note_add),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.person), onPressed: () => profileOnClick()),
            IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.red.shade900,
                ),
                onPressed: () => logOutOnClick())
          ],
          backgroundColor: Colors.transparent,
          title: Text(widget.userName,style: TextStyle(fontSize: 26),),
        ),
        body: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 12.6,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/img/notepadtop3.png'),
                          fit: BoxFit.fitWidth)),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: Colors.white70,
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Center(
                    child: tabSelector(),
                  ),
                ),
              ],
            )),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[400],
            backgroundColor: Colors.black26,
            currentIndex: tabIndex,
            onTap: (int index) {
              setState(() {
                tabIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                title: Text('Diaries',style: TextStyle(fontSize: 17),),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('Calendar',style: TextStyle(fontSize: 17)),
              ),
            ]),
      );
    } else if (page == 1) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: ()=>{newPasswordSaveButtonClick()},
        backgroundColor: Colors.green,
        child: Icon(Icons.check),
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.delete_forever,color: Colors.red.shade700,), onPressed: ()=>{
              deleteUser(widget.userId,widget.userName),
            })
          ],
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => {
                    setState(() {
                      newPassword.text = '';
                      newPassword2.text = '';
                      page = 0;
                    })
                  }),
        ),
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
                    enabled: false,
                    style: TextStyle(
                      fontSize: 20
                    ),
                    maxLength: 12,
                    showCursor: false,
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: 'Enter New Username',
                        hintStyle: TextStyle(fontSize: 15),
                        labelText: widget.userName,
                        labelStyle: TextStyle(fontSize: 20),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  TextField(
                    controller: newPassword,
                    style: TextStyle(
                      fontSize: 20
                    ),
                    maxLength: 12,
                    obscureText: page1pf1Secure,
                    showCursor: false,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(page1pf1Secure == true ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey
                          ), 
                          onPressed: ()=>{
                          setState(() {
                            page1pf1Secure = !page1pf1Secure;
                          })
                        }),
                        counterText: '',
                        hintText: '',
                        hintStyle: TextStyle(fontSize: 15),
                        labelText: 'New Password',
                        labelStyle: TextStyle(fontSize: 19),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  TextField(
                    controller: newPassword2,
                    style: TextStyle(
                      fontSize: 20
                    ),
                    maxLength: 12,
                    obscureText: page1pf2Secure,
                    showCursor: false,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(page1pf2Secure == true ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey
                          ), 
                          onPressed: ()=>{
                          setState(() {
                            page1pf2Secure = !page1pf2Secure;
                          })
                        }),
                        counterText: '',
                        hintText: '',
                        hintStyle: TextStyle(fontSize: 15),
                        labelText: 'New Password',
                        labelStyle: TextStyle(fontSize: 19),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                ],
              )),
            ),
          ),
      );
    } else if (page == 2) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), 
            onPressed: () =>{
              if (newDiaryTitle.text == '' && newDiaryContent.text == '') {
                setState((){
                  page = 0;
                })
              }else{
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('Do you really want to exit before saving? Your data will be deleted!'),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                newDiaryContent.text = '';
                                newDiaryTitle.text = '';
                                page = 0;
                              });
                            },
                            child: Text('OK')),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No')),
                      ],
                    );
                  })
              }
            }
          ),
        ),
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            saveNewDiary(),
          },
          backgroundColor: Colors.green.shade500,
          child: Icon(Icons.check),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 12.6,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/img/notepadtop3.png'),
                          fit: BoxFit.fitWidth)),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15,left: 10,right: 10,top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: Colors.white70,
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          style: TextStyle(
                            fontSize: 20
                          ),
                          controller: newDiaryTitle,
                          maxLength: 20,
                          showCursor: false,
                          decoration: InputDecoration(
                              hintText: 'Diary Title',
                              hintStyle: TextStyle(fontSize: 16),
                              labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 19),
                              prefixIcon: Icon(Icons.title),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                        ),
                        TextField(
                          style: TextStyle(
                            fontSize: 20
                          ),
                          controller: newDiaryContent,
                          maxLength: 800,
                          maxLines: 800,
                          minLines: 3,
                          showCursor: false,
                          
                          decoration: InputDecoration(
                              
                              hintText: 'Diary Content',
                              hintStyle: TextStyle(fontSize: 16),
                              labelText: 'Diary',
                              labelStyle: TextStyle(fontSize: 19),
                              prefixIcon: Icon(Icons.mode_edit),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                        ),
                      ],
                    )
                  ),
                ),
                
              ],
            )),
        )
      );
    }
    else if(page == 3){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), 
            onPressed: () =>{
              setState((){
                page = 0;
              })
            }
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 12.6,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/img/notepadtop3.png'),
                          fit: BoxFit.fitWidth)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.only(bottom: 15,top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: Colors.white70,
                  ),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                        padding: EdgeInsets.only(left: 30,top:5,bottom: 3),
                        color: Colors.red.shade400,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: selectedDiaryDate == 0 ? 10 : 0),
                        child: thanCalendar == false ? splitDateInList(selectedDiaryDate) : Text(calendarViewTitleDate,style: TextStyle(fontSize: 15,color: Colors.white),),
                      ),
                        Container(
                          child: Text(selectedDiaryTitle,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                          padding: EdgeInsets.only(left: 20,top: 10,bottom:10,right: 20),
                        ),
                        Divider(
                          endIndent: 1,
                          height: 1,
                          color: Colors.red.shade400,
                          thickness: 1,
                        ),
                        Container(
                          child: Text(selectedDiaryContent,style: TextStyle(fontSize: 19,color: Colors.black87),),
                          padding: EdgeInsets.only(left: 20,top: 20,bottom:2,right: 20),
                        ),
                      ],
                    )
                  ),
                ),
                
              ],
            )),
        )
      );
    }
  }

  newPasswordSaveButtonClick(){
    if (newPassword2.text == '' || newPassword.text == '') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('New Password can\'t be left blank!'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          });
    }else{
      if (newPassword.text==newPassword2.text) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Are You Sure?'),
              content: Text('Do you want to update your password?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      dbHelper.updateAuthorPassword(widget.userId, newPassword.text).then((r)=>{
                        Navigator.of(context).pop(),
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Warning'),
                              content: Text('You must relog-in!'),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => MainPage()));
                                    },
                                    child: Text('OK')),
                              ],
                            );
                          })

                      });
                    },
                    child: Text('OK')),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No')),
              ],
            );
          });
      }else{
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
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          });

      }
    }
  }

  saveNewDiary(){
    if(newDiaryContent.text == '' || newDiaryTitle.text == '' ){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Title and content can not be left blank!'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK')),
            ],
          );
        });
    }
    else{
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Are You Sure?'),
            content: Text('Do you want to save the new diary?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    newDiary(newDiaryTitle.text, newDiaryContent.text, widget.userId);
                    Navigator.of(context).pop();
                  },
                  child: Text('OK')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });
    }
  }

  newDiary(String diaryTitle, String diaryContent, int diaryAuthorId) async{
    String date = getDate();
    Diary newdiary = Diary(diaryTitle, diaryContent, diaryAuthorId, date);

    await dbHelper.newDiary(newdiary).then((r)=>{
      setState((){
        newDiaryContent.text = '';
        newDiaryTitle.text = '';
        hasDataDiaries = false;
        hasDataDates = false;
        getDiariesWithDate(widget.userId);
        getAllDiaries(widget.userId);
        page = 0;
      })
    });

  }

  deleteUser(int userId,String userName) async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Are You Sure?'),
            content: Text('Do you really want to delete $userName? Whole data will be deleted!'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteUserAction(userId);
                    
                  },
                  child: Text('OK')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });


      // Navigator.pushReplacement(
      //                 context,
      //                 MaterialPageRoute(builder: (context) => MainPage()),
      //               );
      
    // });
  }

  deleteUserAction(int userId) async{
    await dbHelper.deleteAuthor(userId);
    await dbHelper.deleteDiariesWithAuthorId(userId).then((r)=>{

      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    )
      
    });

  }

  tabSelector() {
    
    if (hasDataDates && hasDataDiaries) {
      if (tabIndex == 0) {
        return Center(
            child: ListView.builder(
          itemCount: diaryDates.length,
          itemBuilder: (context, indexOut) => Container(
              child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  
                  
                ),
                padding: EdgeInsets.only(left: 30,top: 5,bottom: 2),
                width: double.infinity,
                margin: EdgeInsets.only(top: indexOut == 0 ? 10 : 0),
                child: splitDateInList(indexOut),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allDiaries.length,
                  itemBuilder: (context, index) => allDiaries[index]
                              ['diaryDate'] ==
                          diaryDates[indexOut]['diaryDate']
                      ? diariesListItem(index,indexOut)
                      : Container())
            ],
          )),
        ));
      } else if (tabIndex == 1) {
        
        return Container(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
            child: calendarView(),
          ),
          )
        );
        
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

   getDate(){
      String day = DateTime.now().day.toString();
      String month = DateTime.now().month.toString();
      String year = DateTime.now().year.toString();
      if (month.length == 1) {
          month = '0$month';
      }
      if (day.length == 1) {
          day = '0$day';
      }
      String dateToday = '$year$month$day';
      return dateToday;

  }

  diariesListItem(int index,int indexOut) {
    return Container(
      
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        highlightColor: Colors.yellow.shade100,
        splashColor: Colors.yellow.shade100,
        onTap: ()=>{
          setState((){
            selectedDiaryTitle = allDiaries[index]['diaryTitle'];
            selectedDiaryContent = allDiaries[index]['diaryContent'];
            thanCalendar = false;
            selectedDiaryDate = indexOut;
            page = 3;
          })
        },
        child: Container(
          alignment: Alignment.centerLeft,
          // height: MediaQuery.of(context).size.height / 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(allDiaries[index]['diaryTitle'],style: TextStyle(fontSize: 18),),
              //     Icon(Icons.chevron_right)
              //   ],
              // ),
              Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                color: Colors.white30,
                child: ListTile(
                dense: true,
                title: Text(allDiaries[index]['diaryTitle'],style: TextStyle(fontSize: 18),),
                trailing: Icon(Icons.chevron_right),
                
              ),
              )
              // Divider(
              //   endIndent: 1,
              //   height: 1,
              //   color: Colors.black,
              // )
            ],
          )),
      )
    );
  }

  splitDateInList(int indexOut) {
    var a = diaryDates[indexOut]['diaryDate'].toString();
    List b = a.split('');
    // debugPrint(b.toString());

    String day = "${b[6]}" + "${b[7]}";
    String month = "${b[4]}" + "${b[5]}";
    String year = "${b[0]}" + "${b[1]}" + "${b[2]}" + "${b[3]}";

    // debugPrint('$day-$month-$year');

    return Text('$day-$month-$year',style: TextStyle(fontSize: 15,color: Colors.white),);
  }

  // newDiary() async {
  //   Diary diary =
  //       new Diary('BaşlıkDeneme', 'İçerikDeneme', widget.userId, '20190815');
  //   await dbHelper.newDiary(diary).then((r) => {
  //         // Navigator.pushReplacement(
  //         //     context, MaterialPageRoute(builder: (context) => MainPage()))
  //         setState(() {
  //           hasDataDiaries = false;
  //           hasDataDates = false;
  //           getDiariesWithDate(widget.userId);
  //           getAllDiaries(widget.userId);
  //           page = 0;
  //         })
  //       });
  // }

  getDiariesWithDate(int authorId) async {
    await dbHelper.groupedDiariesWithDate(authorId).then((r) => {
          setState(() {
            diaryDates = r;
            hasDataDates = true;
          })
        });

    // debugPrint('$diaryDates'); ////////////////////////////////////////////
  }

  getAllDiaries(int authorId) async {
    await dbHelper.allDiariesWithAuthorId(authorId).then((r) => {
          setState(() {
            allDiaries = r;
            hasDataDiaries = true;
          })
        });

    // debugPrint('$allDiaries');///////////////////////
  }

  profileOnClick() {
    setState(() {
      page = 1;
    });
  }

  logOutOnClick() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Are You Sure?'),
            content: Text('Do you want to log out?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },
                  child: Text('OK')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });
  }







  calendarView(){
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child:TableCalendar(
            formatAnimation: FormatAnimation.scale,
            
            events: _events,
              initialSelectedDay: DateTime.now(),
              onHeaderTapped: ((r)=>{
                setState((){
                  _calendarController.calendarFormat == CalendarFormat.month ? _calendarController.setCalendarFormat(CalendarFormat.week) : _calendarController.setCalendarFormat(CalendarFormat.month);
                })
              }),
              
              availableGestures: AvailableGestures.horizontalSwipe,
              onDaySelected: (date, events)=>{
                if (_calendarController.calendarFormat == CalendarFormat.month) {
                  setState((){
                    _calendarController.setCalendarFormat(CalendarFormat.week);
                  })
                },
                setState((){
                  selectedDateDb = '${date.toString().split('')[0]}${date.toString().split('')[1]}${date.toString().split('')[2]}${date.toString().split('')[3]}${date.toString().split('')[5]}${date.toString().split('')[6]}${date.toString().split('')[8]}${date.toString().split('')[9]}';
                  
                  calendarViewTitleDate = '${date.toString().split('')[8]}${date.toString().split('')[9]}-${date.toString().split('')[5]}${date.toString().split('')[6]}-${date.toString().split('')[0]}${date.toString().split('')[1]}${date.toString().split('')[2]}${date.toString().split('')[3]}';
                })
              },
              onDayLongPressed: (date, evets)=>{
                setState((){
                   _calendarController.calendarFormat == CalendarFormat.month ? _calendarController.setCalendarFormat(CalendarFormat.week) : _calendarController.setCalendarFormat(CalendarFormat.month);

                })
              },
              availableCalendarFormats: {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week'
              },
              headerStyle: HeaderStyle(
                formatButtonShowsNext: false,
                centerHeaderTitle: true,
                formatButtonVisible: true,
                headerPadding: EdgeInsets.all(5),
                titleTextStyle: TextStyle(
                  fontSize: 20
                  
                ),
                
              ),
              initialCalendarFormat: CalendarFormat.month,
              
              calendarStyle: CalendarStyle(
                markersAlignment: Alignment.topRight,
                markersMaxAmount: 1,
                // markersPositionRight: 5,
                markersColor: Colors.red,
                todayColor: Colors.blue.shade200,
                selectedColor: Colors.yellow.shade100,
                selectedStyle: TextStyle(
                  color: Colors.black
                )
              ),
              calendarController: _calendarController,
              
            )
        ),
        Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 30,top:5,bottom: 3),
                color: Colors.red.shade400,
                width: double.infinity,
                child: Text(calendarViewTitleDate,style: TextStyle(color: Colors.white),),
              ),
              Container(
                child: ListView.builder(
                  itemCount: allDiaries.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index) => selectedDateDb == allDiaries[index]['diaryDate'] ? diariesSelectWithCalendar(index) : Container()
                  )
              )
            ],
          ), 
        )
        
      ],
    ),
    );






  }



  diariesSelectWithCalendar(int index){
    return Container(
      
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        highlightColor: Colors.yellow.shade100,
        splashColor: Colors.yellow.shade100,
        onTap: ()=>{
          setState((){
            selectedDiaryTitle = allDiaries[index]['diaryTitle'];
            selectedDiaryContent = allDiaries[index]['diaryContent'];
            thanCalendar = true;
            selectedDiaryDate = index;
            page = 3;
          })
        },
        child: Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height / 15,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                color: Colors.white30,
                child: ListTile(
                dense: true,
                title: Text(allDiaries[index]['diaryTitle'],style: TextStyle(fontSize: 18),),
                trailing: Icon(Icons.chevron_right),
                
              ),
              )
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(allDiaries[index]['diaryTitle'],style: TextStyle(fontSize: 18),),
              //     Icon(Icons.chevron_right)
              //   ],
              // ),
              // Divider(
              //   endIndent: 1,
              //   height: 1,
              //   color: Colors.black,
              // )
            ],
          )),
      )
    );

  }



}
