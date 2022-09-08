import 'dart:convert';
import 'package:http/http.dart';
import 'package:models/warehouse_models.dart';
import 'package:repository/Warehouse_repository.dart';

import '../domain/warehouses.dart';


 
   void loadData2() async {
    String username = 'Администратор'; //_emailInputText;
    String password = '  '; //_pwdInputText;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    const url =
        'http://1c.vct.kz:1998/Demo_buh_Aisana/hs/MobileIntegrate/getWarehouse/';
    final response = await post(Uri.parse(url), headers: <String, String>{
      'authorization': basicAuth
    }); //Basic 0JDQtNC80LjQvdC40YHRgtGA0LDRgtC+0YA6ICA=
    final wrhList = jsonDecode(response.body);
    // final wrh = <Warehouse>[];
    for (int i = 0; i < wrhList.length; i++) {

      final Warehouse_model = warehouse_Model(
                          code: utf8.decode(Warehouse.fromJson(wrhList[i]).code.codeUnits),
                          title: utf8.decode(Warehouse.fromJson(wrhList[i]).title.codeUnits));
                      WarehouseRepository().addWarehouse(Warehouse_model);

      // wrh.add(Warehouse.fromJson(wrhList[i]));
    }


    // return wrh; //body.map<Warehouse>(Warehouse.fromJson).toList();
  }





//  loadData(warehouses) {
//   final wrh = <Warehouse>[];
//     getData().then((response){
//     if(response.statusCode == 200){
//       List wrhList = json.decode(response.body);
//       for(int i = 0; i< wrhList.length; i++){
//           wrh.add(Warehouse.fromJson(wrhList[i]));
//       }
//      warehouses = wrh;
//    return warehouses;
//       print(response.body );
//     }
//     else{
//       print(response.statusCode); 
//       return <Warehouse>[];
//     }
//   }).catchError((error){
//     debugPrint(error.toString()); 
//   });
// }
