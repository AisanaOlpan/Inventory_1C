class db_Warehouse{
  String title;
  String code;
  // String description;
  // String inventoryNum;

  db_Warehouse({ this.title = '',  this.code = ''});

factory db_Warehouse.fromMap(Map<String, dynamic> json) => db_Warehouse(
      code: json['code']?? '',
      title: json['title']?? '',
     );

       Map<String, dynamic> toMap() => {
      "code" : code,
      "title" : title
    };

}