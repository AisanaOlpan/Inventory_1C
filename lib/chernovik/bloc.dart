import 'package:flutter/material.dart';
import 'package:models/tmz_models.dart';
import 'package:repository/TMZ_repository.dart';

class BLOCK extends StatefulWidget {
  BLOCK({Key? key}) : super(key: key);

  @override
  State<BLOCK> createState() => _BLOCKState();
}

class _BLOCKState extends State<BLOCK> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<tmz_Model>>(
        future:   tmzRepository().getAllTMZ('000000001'),
        builder: (BuildContext context, AsyncSnapshot<List<tmz_Model>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                tmz_Model item = snapshot.data![index];
                return  Dismissible(
   key: UniqueKey(),
   background: Container(color: Colors.red),
   onDismissed: (direction) {
   tmzRepository().deleteTMZ(item);
   },
                
                child: ListTile(
                  title: Text(item.title),
                  leading: Text(item.id.toString()),
                  // trailing: Checkbox(
                  //   onChanged: (bool value) {
                  //     // DBProvider.db.blockClient(item);
                  //     // setState(() {});
                  //   },
                  //   value: item.blocked,
                  // ),
                ));
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
      
          final tmzModel = tmz_Model(
                          id: '1' +
                             ' 000000001',
                          code:'234',
                          title: 'ddff',
                          quantity: 5,
                          barcode: 'jfjkfnj',
                          Warehouse_code: '000000001');
         
          
         tmzRepository().addTMZ(tmzModel);
          setState(() {});
        },
      ),
    );
  }
}