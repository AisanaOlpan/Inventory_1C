class db_TMZ {
  String id;
  String code;
  String title; 
  String barcode;
  String Warehouse_code;
  int quantity;

  db_TMZ({
    this.id = '',
    this.code = '',
     this.title = '', 
     this.barcode = '',
    this.Warehouse_code = '',
    this.quantity = 0
     });
     factory db_TMZ.fromMap(Map<String, dynamic> json) => db_TMZ(
     id: json['id']?? '',
      code: json['code']?? '',
      title: json['title']?? '',
      barcode: json['barcode']?? '',
       Warehouse_code: json['Warehouse_code']?? '',
       quantity: json['quantity']?? 0
     );

       Map<String, dynamic> toMap() => {
        "id" : id,
      "code" : code,
      "title" : title,
      "barcode" : barcode,
      'Warehouse_code' : Warehouse_code,
      'quantity': quantity

    };
}