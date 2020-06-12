class Diary{
  int _diaryId;
  String _diaryTitle;
  String _diaryContent;
  int _diaryAuthorId;
  String _diaryDate;

	int get diaryId => _diaryId;

  set diaryId(int value) {
    _diaryId = value;
  }

  String get diaryTitle => _diaryTitle;

  set diaryTitle(String value){
    _diaryTitle = value;
  }

  String get diaryContent => _diaryContent;

  set diaryContent(String value){
    _diaryContent = value;
  }

  String get diaryDate => _diaryDate;

  set diaryDate(String value){
    _diaryDate = value;
  }

  int get diaryAuthorId => _diaryAuthorId;

  set diaryAuthorId(int value) {
    _diaryAuthorId = value;
  }

  Diary(this._diaryTitle,this._diaryContent,this._diaryAuthorId,this._diaryDate);
  Diary.withID(this._diaryId,this._diaryTitle,this._diaryContent,this._diaryAuthorId,this._diaryDate);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['diaryId'] = _diaryId;
    map['diaryTitle'] = _diaryTitle;
    map['diaryContent'] = _diaryContent;
    map['diaryAuthorId'] = _diaryAuthorId;
    map['diaryDate'] = _diaryDate;


    return map;
  }

  Diary.fromMap(Map<String, dynamic> map){
    this._diaryId =  map['diaryId'];
    this._diaryTitle =  map['diaryTitle'];
    this._diaryContent =  map['diaryContent'];
    this._diaryAuthorId =  map['diaryAuthorId'];
    this._diaryDate =  map['diaryDate'];


  }


}