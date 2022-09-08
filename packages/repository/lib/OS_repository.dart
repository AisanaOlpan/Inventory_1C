import 'package:models/models.dart';
import 'package:services/data_models/db_os.dart';
import 'package:services/database.dart';

class osRepository{
Future<void> addOs(Model osmodel) async{
  await DBProvider.db.addOs(db_Os(
    id: osmodel.id,
    code: osmodel.code,
    title: osmodel.title,
    Warehouse_code: osmodel.Warehouse_code
  ));
}

Future <List<Model>> getAllOS(param) async {
  final All_os = await DBProvider.db.getAllOS(param);
  return All_os.map((e) => Model(id: e.id, code: e.code, title: e.title, Warehouse_code: e.Warehouse_code)).toList();
}

}