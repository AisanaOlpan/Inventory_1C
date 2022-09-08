import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inventory_1c/components/scannerPage2.dart';
import 'package:repository/Warehouse_repository.dart';

class ExPage extends StatefulWidget {
  @override
  State<ExPage> createState() => _ExPage();
}

class _ExPage extends State<ExPage> {
  var warehouse = [];
  // Future<List<Warehouse>> warehouse = loadData2();

  // static Future<List<Warehouse>> loadData2() async {
  //   String username = 'Администратор'; //_emailInputText;
  //   String password = '  '; //_pwdInputText;
  //   String basicAuth =
  //       'Basic ' + base64Encode(utf8.encode('$username:$password'));
  //   print(basicAuth);

  //   const url =
  //       'http://1c.vct.kz:1998/Demo_buh_Aisana/hs/MobileIntegrate/getWarehouse/';
  //   final response = await post(Uri.parse(url), headers: <String, String>{
  //     'authorization': basicAuth
  //   }); //Basic 0JDQtNC80LjQvdC40YHRgtGA0LDRgtC+0YA6ICA=
  //   final wrhList = jsonDecode(response.body);
  //   final wrh = <Warehouse>[];
  //   for (int i = 0; i < wrhList.length; i++) {
  //     wrh.add(Warehouse.fromJson(wrhList[i]));
  //   }
  //   return wrh; //body.map<Warehouse>(Warehouse.fromJson).toList();
  // }

  @override
  void initState() {
    clearFilter();
    super.initState();
  }

  var filterTitle = '';
  var filterTitleController = TextEditingController();
  var filterCode = '';
  var filterCodeController = TextEditingController();
  var filterText = '';
  var filterHeight = 0.0;

  List filter() {
    setState(() {
      if (filterTitle.isNotEmpty) filterText += '/' + filterTitle;
      filterHeight = 0;
    });
    var list = warehouse;
    return list;
  }

  List clearFilter() {
    setState(() {
      filterTitleController.clear();
      filterHeight = 0;
      filterTitle = '';
      filterText = '';
    });
    var list = warehouse;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var warehousesList = Expanded(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: AppBar(
      //   title: Text('Склады из 1C'),
      //   centerTitle: true,
      // ),

      body: Center(
          child: FutureBuilder(
        future: WarehouseRepository().getAllWarehouse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var warehouse_List = snapshot.data; //as List<warehouse_Model>;
          return buildWRH(warehouse_List);
        },
      )),
    ));

    var filterInfo = Container(
      margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      height: 40,
      child: RaisedButton(
        child: Row(children: <Widget>[
          Icon(Icons.filter_list),
          Text(
            filterText,
            style: TextStyle(),
            overflow: TextOverflow.ellipsis,
          )
        ]),
        onPressed: () {
          setState(() {
            filterHeight = (filterHeight == 0.0 ? 150.0 : 0.0);
          });
        },
      ),
    );

    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              controller: filterTitleController,
              decoration: const InputDecoration(labelText: 'Название склада'),
              onChanged: (String val) => setState(() => filterTitle = val),
              style: TextStyle(color: Colors.black),
            ),
            // TextFormField(
            //   controller: filterCodeController,
            //   decoration: const InputDecoration(labelText: 'Код склада'),
            //   onChanged: (String val) => setState(() => filterCode= val),
            // ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    onPressed: () {
                      filter();
                    },
                    child: Text(
                      'Apple',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        clearFilter();
                      },
                      child:
                          Text('Clear', style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                    ))
              ],
            )
          ]),
        ),
      ),
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      height: filterHeight,
    );

    return Column(
      children: <Widget>[
        // filterInfo, filterForm,
        warehousesList
      ],
    );
  }

  Widget buildWRH(wr) => ListView.builder(
        itemCount: wr.length,
        itemBuilder: (context, index) {
          final wrh = wr[index];

          return Card(
            color: Colors.white12,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            
            ),
            child: ListTile(
              title: Text(wrh.code),
              subtitle: Text(
                wrh.title,
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            ScanPage2(WarehouseCode: wrh.code))));
              },
            ),
          );
        },
      );
}
