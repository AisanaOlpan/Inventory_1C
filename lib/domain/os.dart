class OSclass{
  String title;
  String code;
  String barCode;
  // String inventoryNum;

  OSclass({required this.title, required this.code, required this.barCode});

  factory OSclass.fromJson(Map<String, dynamic> json){
    return OSclass(
      code: json['code'].toString(), title: json['title'].toString(), barCode: json['barCode'].toString()

    );

  }
}