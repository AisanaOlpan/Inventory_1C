class Warehouse{
  String title;
  String code;
  // String description;
  // String inventoryNum;

  Warehouse({required this.title, required this.code});

  factory Warehouse.fromJson(Map<String, dynamic> json){
    return Warehouse(
      code: json['code'].toString(), title: json['title'].toString(),

    );

  }
}