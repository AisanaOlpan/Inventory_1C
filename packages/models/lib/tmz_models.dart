class tmz_Model {
  final String id;
 final String code;
 final String title;
 final int quantity;
 final String barcode;
  final String Warehouse_code;

 tmz_Model({
  required this.id,
  required this.code,
  required this.title,
  required this.quantity,
  required this.barcode,
  required this.Warehouse_code
 });

    Map<String, dynamic> toJson() => {
       
        '"code"': '"$code"',
          '"title"': '"$title"',
  '"quantity"': '"$quantity"',
  '"barcode"': '"$barcode"',
  '"id"': '"$id"',
  '"Warehouse_code"' :'"$Warehouse_code"'
      };
   
}