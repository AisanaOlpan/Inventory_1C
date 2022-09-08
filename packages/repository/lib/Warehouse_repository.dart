import 'package:models/warehouse_models.dart';
import 'package:services/data_models/db_warehouse.dart';
import 'package:services/database.dart';

class WarehouseRepository{
Future<void> addWarehouse(warehouse_Model Warehousemodel) async{
  await DBProvider.db.addWarehouse(db_Warehouse(
    code: Warehousemodel.code,
    title: Warehousemodel.title
  ));
}

Future <List<warehouse_Model>> getAllWarehouse() async {
  final All_Warehouse = await DBProvider.db.getAllWarehouse();
  return All_Warehouse.map((e) => warehouse_Model(code: e.code, title: e.title)).toList();
}

 
}