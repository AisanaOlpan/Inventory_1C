import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inventory_1c/components/ListPageProduct.dart';
import 'package:inventory_1c/domain/os.dart';
import 'package:models/tmz_models.dart';
import 'package:repository/TMZ_repository.dart';
import 'package:scan/scan.dart';
import '../domain/tmz.dart';
import '../services/authFirebase.dart';

class ScanPage2 extends StatefulWidget {
  final String WarehouseCode;
  final tmz;
  ScanPage2({Key? key, required this.WarehouseCode, this.tmz = null})
      : super(key: key);

  @override
  State<ScanPage2> createState() => _ScanPage2();
}

class _ScanPage2 extends State<ScanPage2> {
  var _scanResult = '';
  bool err = false;
  TextEditingController _productController = TextEditingController();
  ScanController controller = ScanController();
  static Future<List<OSclass>> loadOSData(String result) async {
    String username = 'Администратор'; //_emailInputText;
    String password = '  '; //_pwdInputText;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var url =
        'http://1c.vct.kz:1998/Demo_buh_Aisana/hs/MobileIntegrate/getCode/' +
            result;
    final response = await post(Uri.parse(url),
        headers: <String, String>{'authorization': basicAuth});
    //  try{
    final wrhList = response.statusCode == 404 ? '' : jsonDecode(response.body);
    final wrh = <OSclass>[];
    for (int i = 0; i < wrhList.length; i++) {
      wrh.add(OSclass.fromJson(wrhList[i]));
    }
    return wrh; //} on Exception catch(e){
//return [];
//print(e.toString());
    // }
  }

  static Future<List<TMZclass>> loadTMZData(String result) async {
    String username = 'Администратор'; //_emailInputText;
    String password = '  '; //_pwdInputText;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var url =
        'http://1c.vct.kz:1998/Demo_buh_Aisana/hs/MobileIntegrate/getTmzCode/' +
            result;
    final response = await post(Uri.parse(url),
        headers: <String, String>{'authorization': basicAuth});
    //  try{
    final wrhList = response.statusCode == 404 ? '' : jsonDecode(response.body);
    final wrh = <TMZclass>[];
    for (int i = 0; i < wrhList.length; i++) {
      wrh.add(TMZclass.fromJson(wrhList[i]));
    }
    return wrh; //} on Exception catch(e){
//return [];
//print(e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Future<List<OSclass>> os = loadOSData(_scanResult);
    Future<List<TMZclass>> product = loadTMZData(_scanResult);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text('Скан'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              AuthService().logOut();
            },
            icon: Icon(
              Icons.supervised_user_circle,
              color: Colors.white54,
            ),
            label: SizedBox.shrink(),
          ), //SizedBox.shrink( )- просто занимает место и заполняет обязательный параметр
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: product, //os,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final productData = snapshot.data!;
                  return buildProduct(productData);
                } else {
                  return Text('No data');
                }
              },
            ),
            const Text(''),
          ],
        ),
      ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: _showBarcodeScanner,
          // tooltip: 'Сканировать',
          backgroundColor: Colors.yellow,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: const Icon(
            Icons.scanner,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  _showBarcodeScanner() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Scaffold(
                appBar: _buildBarcodeScannerAppBar(),
                body: _buildBarcodeScannerBody(),
              ));
        });
      },
    );
  }

  AppBar _buildBarcodeScannerAppBar() {
    return AppBar(
      bottom: PreferredSize(
        child: Container(color: Colors.yellow, height: 4.0),
        preferredSize: const Size.fromHeight(4.0),
      ),
      title: const Text('Наведите на штрихкод'),
      elevation: 0.0,
      backgroundColor: const Color(0xFF333333),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Center(
          child: Icon(
            Icons.cancel,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () => controller.toggleTorchMode(),
            child: const Icon(Icons.flashlight_on),
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeScannerBody() {
    return SizedBox(
      height: 400,
      child: ScanView(
        controller: controller,
        scanAreaScale: .7,
        scanLineColor: Colors.yellow,
        onCapture: (data) {
          setState(
            () {
              _scanResult = data;
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }

  Widget buildProduct(productlists) {
    final wrh = productlists.length == 0 ? <TMZclass>[] : productlists[0];

    if (widget.tmz != null) {
      return _formDesc('OK', widget.tmz);
    } else {
      return productlists.length == 0 ? Text('no data') : _formDesc('OK', wrh);
    }

    // return Card(
    //   color: Colors.white12,
    //   child: ListTile(
    //     title: Text(wrh.code),
    //     subtitle: Text(
    //       utf8.decode(wrh.title.codeUnits),
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white),
    //   ),
    // );
  }

  Widget _formDesc(String label, wrh) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: _descProduct('Описание', wrh),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: _input('Введите количество', _productController, false),
              ),
              // SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(bottom: 30, top: 20),
                //  width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 50,
                  //  width: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _btnLog(
                    label,
                    () {
                      final tmzModel = tmz_Model(
                          id: widget.tmz != null
                              ? widget.tmz.id.toString()
                              : utf8.decode(wrh.code.codeUnits) +
                                  widget.WarehouseCode,
                          code: widget.tmz != null
                              ? widget.tmz.code.toString()
                              : utf8.decode(wrh.code.codeUnits),
                          title: widget.tmz != null
                              ? widget.tmz.title.toString()
                              : utf8.decode(wrh.title.codeUnits),
                          quantity: int.parse(_productController.text),
                          barcode: widget.tmz != null
                              ? widget.tmz.barcode.toString()
                              : utf8.decode(wrh.barCode.codeUnits).toString(),
                          Warehouse_code: widget.tmz != null
                              ? widget.tmz.Warehouse_code.toString()
                              : widget.WarehouseCode);
                      try {
                        setState(
                          () {
                            tmzRepository().addTMZ(tmzModel);
                          },
                        );
                      } on Exception catch (e) {
                        err = true;
                      }
                      setState(
                        () {
                          //  Fluttertoast.showToast(
                          //   msg: err ? 'OS exists!' : 'OS added!',
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.CENTER,
                          //   // timeInSecForIosWeb: 1, для ios
                          //   backgroundColor: err ? Colors.red :Colors.yellow,
                          //   textColor: Colors.white,
                          //   fontSize: 16.0);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Listpage(
                                        WarehouseCode: widget.WarehouseCode,
                                        TMZ: true,
                                      ))).then((value) => setState(() {},),);
                        },
                      );
                    },
                  ),
                ),
                // _btnLog эта сама кноп которая вызывает действие которая передана через параметр func_btn(пример _registerBtnAction или _loginBtnAction)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _input(String hint, TextEditingController _controller, bool obscure) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 20),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _controller,
        // obscureText: obscure,
        style: TextStyle(fontSize: 20, color: Colors.white),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 16, color: Colors.white30),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width / 1.4,
    );
  }

  Widget _descProduct(String hintText, wrh) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Text(
                    'Наименование: ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    widget.tmz != null
                        ? widget.tmz.title
                        : utf8.decode(wrh.title.codeUnits).toString(),
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Text(
                    'Штрихкод: ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    widget.tmz != null
                        ? widget.tmz.barcode
                        : utf8.decode(wrh.barCode.codeUnits).toString(),
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Text(
                    'Инв. номер: ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    widget.tmz != null
                        ? widget.tmz.code
                        : utf8.decode(wrh.code.codeUnits).toString(),
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          //     Align(
          // alignment: Alignment.centerLeft,
          // child: Padding(
          //     padding: EdgeInsets.only(left: 30, top: 20),
          //     child: Text(
          //       'Единицы:',
          //       style: TextStyle(color: Colors.white70, fontSize: 18),
          //     )))
        ],
      ),
    );
  }

  Widget _btnLog(String text, void func()) {
    return RaisedButton(
      splashColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).primaryColor,

      //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
      color: Colors.yellow,
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
      ),
      onPressed: () {
        func();
        // loadData();
      },
    );
  }
}
