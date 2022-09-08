class TMZclass{
  String title;
  String code;
  String barCode;

  // String inventoryNum;

  TMZclass({required this.title, required this.code, required this.barCode});

  factory TMZclass.fromJson(Map<String, dynamic> json){
    return TMZclass(
      code: json['code'].toString(), title: json['title'].toString(), barCode: json['barCode'].toString()

    );

  }
}