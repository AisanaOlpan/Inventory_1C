import 'package:models/tmz_models.dart';
import 'package:services/data_models/db_tmz.dart';
import 'package:services/database.dart';

class tmzRepository{
Future<void> addTMZ(tmz_Model tmzmodel) async{
  await DBProvider.db.addTMZ(db_TMZ(
    id: tmzmodel.id,
    code: tmzmodel.code,
    title: tmzmodel.title,
    quantity: tmzmodel.quantity,
    barcode: tmzmodel.barcode,
    Warehouse_code: tmzmodel.Warehouse_code
  ));
}

Future <List<tmz_Model>> getAllTMZ(param) async {
  final All_os = await DBProvider.db.getAllTMZ(param);
  return All_os.map((e) => tmz_Model(id: e.id, code: e.code, title: e.title, quantity: e.quantity, barcode: e.barcode, Warehouse_code: e.Warehouse_code)).toList();
}

getAllTMZjson <String> (param) {
  final dataJson =  DBProvider.db.getAllTMZjson(param);
  return dataJson;
}

Future updateTMZ(tmz_Model tmzmodel) async{
  final result = await DBProvider.db.UpdateTMZ(db_TMZ(id: tmzmodel.id, code: tmzmodel.code, title: tmzmodel.title, barcode: tmzmodel.barcode, Warehouse_code: tmzmodel.Warehouse_code, quantity: tmzmodel.quantity ));
return result;
}

Future deleteTMZ(tmz_Model tmzmodel) async{
  final result = await DBProvider.db.deleteTMZ(db_TMZ(id: tmzmodel.id, code: tmzmodel.code, title: tmzmodel.title, barcode: tmzmodel.barcode, Warehouse_code: tmzmodel.Warehouse_code, quantity: tmzmodel.quantity ));
return result;
}

Future deleteAllTMZ(param) async{
  final result = await DBProvider.db.deleteAllTMZ(param);
return result;
}
}