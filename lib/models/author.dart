class Author{
  int _authorId;
  String _authorName;
  String _authorPassword;


  int get authorId => _authorId;

  set authorId(int value) {
    _authorId = value;
  }

  String get authorName => _authorName;

  set authorName(String value){
    _authorName = value;
  }


  String get authorPassword => _authorPassword;

  set authorPassword(String value){
    _authorPassword = value;
  }

  Author(this._authorName,this._authorPassword);
  Author.withID(this._authorId,this._authorName,this._authorPassword);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['authorId'] = _authorId;
    map['authorName'] = authorName;
    map['authorPassword'] = authorPassword;

    return map;
  }

  Author.fromMap(Map<String, dynamic> map){
    this._authorId = map['authorId'];
    this._authorName = map['authorName'];
    this._authorPassword = map['authorPassword'];
  }




}