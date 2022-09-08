class db_Os {
  String id;
  String code;
  String title; 
  String Warehouse_code;

  db_Os({
    this.id = '',
    this.code = '',
    this.title = '', 
    this.Warehouse_code = '',
     });
     factory db_Os.fromMap(Map<String, dynamic> json) => db_Os(
     id: json['is']?? '',
      code: json['code']?? '',
      title: json['title']?? '',
       Warehouse_code: json['Warehouse_code']?? ''
     );

       Map<String, dynamic> toMap() => {
        "id" : id,
      "code" : code,
      "title" : title,
      'Warehouse_code' : Warehouse_code
    };
}