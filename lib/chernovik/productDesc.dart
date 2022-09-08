

import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

import '../services/authFirebase.dart';

class ProductPage extends StatefulWidget {
  final String barcodeText;
  ProductPage({Key? key, required this.barcodeText}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController _productController = TextEditingController();

  var _productCount = 0;

  Widget _descProduct(String hintText) {
    return Container(
        child: Column(children: [
          Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                'Наименование:',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ))),
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                'Штрихкод:',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ))),
              Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                'Артикул:',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ))),Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                'Единицы:',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              )))
    ]));
  }

  Widget _btnLog(String text, void func()) {
    return RaisedButton(
      splashColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).primaryColor,
      color: Colors.yellow,
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 20)),
      onPressed: () {
        func();
        // loadData();
      },
      
    );
  }

  Widget _input(String hint, TextEditingController _controller, bool obscure) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 20),
      child: TextField(
        controller: _controller,
        obscureText: obscure,
        style: TextStyle(fontSize: 20, color: Colors.white),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 20, color: Colors.white30),
          hintText: hint,
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        ),
      ),
   width: MediaQuery.of(context).size.width /1.4, );
  }

  Widget _formDesc(String label, void func_btn()) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: _descProduct('Описание'),
          ),
          Row(children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: _input('Введите количество', _productController, false),
          ),
          //   SizedBox(height: 20,),
          Padding(
              padding: EdgeInsets.only(bottom: 30, top: 20),
              //  width: MediaQuery.of(context).size.width,
              child: Container( 
                height: 50,
                child:_btnLog(label,
                  func_btn)) // _btnLog эта сама кноп которая вызывает действие которая передана через параметр func_btn(пример _registerBtnAction или _loginBtnAction)
        ),])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title:  Text('Описание продукта'),
        leading: Icon(
          Icons.room_preferences ,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                AuthService().logOut();
              },
              icon: Icon(
                Icons.supervised_user_circle,
                color: Colors.yellow,
              ),
              label: SizedBox
                  .shrink()) //SizedBox.shrink( )- просто занимает место и заполняет обязательный параметр
        ],
      ),
      body: _formDesc('OK', () {}),
    ));
  }
}
