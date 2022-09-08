import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inventory_1c/components/1cResponse.dart';

import '../domain/warehouses.dart';

class WarehouseList extends StatefulWidget {
  @override
  State<WarehouseList> createState() => _WarehouseListState();
}

class _WarehouseListState extends State<WarehouseList> {
  var warehouses = <Warehouse>[
    Warehouse(title: 'Test1', code: '111'),
    Warehouse(title: 'Test2', code: '222'),
    Warehouse(title: 'Test3', code: '333'),
    Warehouse(title: 'Test4', code: '444'),
    Warehouse(title: 'Test5', code: '555'),
  ];



  // static Future<List<Warehouse>> loadData2() async {
  //   String username = 'Администратор'; //_emailInputText;
  //   String password = '  '; //_pwdInputText;
  //   String basicAuth =
  //       'Basic ' + base64Encode(utf8.encode('$username:$password'));
  //   print(basicAuth);

  //   const url =
  //       'http://1c.vct.kz:1998/Demo_buh_Aisana/hs/MobileIntegrate/getWarehouse/';
  //   final response =  await post(Uri.parse(url),
  //       headers: <String, String>{'authorization': basicAuth}); //Basic 0JDQtNC80LjQvdC40YHRgtGA0LDRgtC+0YA6ICA=
  //   final wrhList = jsonDecode(response.body);
  //   final wrh = <Warehouse>[];
  //   for(int i = 0; i< wrhList.length; i++){
  //          wrh.add(Warehouse.fromJson(wrhList[i]));
  //     }
  //   return wrh;//body.map<Warehouse>(Warehouse.fromJson).toList();
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

  List<Warehouse> filter() {
    setState(() {
      if (filterTitle.isNotEmpty) filterText += '/' + filterTitle;
      filterHeight = 0;
    });
    var list = warehouses;
    return list;
  }

  List<Warehouse> clearFilter() {
    setState(() {
      filterTitleController.clear();
      filterHeight = 0;
      filterTitle = '';
      filterText = '';
    });
    var list = warehouses;
    return list != null ? list : [];
  }

  @override
  Widget build(BuildContext context) {
  //  Future<List<Warehouse>> wrh = loadData2();
    var warehouseLists = Expanded(
      child: Container(
        child: ListView.builder(
            itemCount: warehouses != null ? warehouses.length : 0,
            itemBuilder: (context, i) {
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromARGB(228, 31, 32, 32)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    // leading: Container( //просто отступ рядом со складом
                    //   child: SizedBox.shrink(),//Icon(Icons.room_preferences, color: Colors.white),
                    //   decoration: BoxDecoration(
                    //       border: Border(
                    //           right:
                    //               BorderSide(width: 1, color: Colors.white24))),
                    // ),
                    title: Text(warehouses[i].title,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    trailing:
                        Icon(Icons.keyboard_arrow_right, color: Colors.white),
                    //subtitle: subtitle(context, warehouses[i]),
                  ),
                ),
              );
            }),
      ),
    );

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
      children: <Widget>[filterInfo, filterForm, warehouseLists],
    );
  }
}
