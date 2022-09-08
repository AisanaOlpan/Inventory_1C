import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_1c/domain/AuthUser.dart';
import 'package:inventory_1c/services/authFirebase.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key? key}) : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
//переменные
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  String _emailInputText = "";
  String _pwdInputText = "";
  bool showLogin = true;
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return Padding(
          padding: EdgeInsets.only(top: 100, left: 30, bottom: 50),
          child: Container(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Вход',
                      style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)))));
    }

    Widget _input(Icon icon, String hint, TextEditingController _controller,
        bool obscure, String texthint) {
      return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      texthint,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ))),
            TextField(
              controller: _controller,
              obscureText: obscure,
              style: TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white10,
                hintStyle: TextStyle(fontSize: 20, color: Colors.white30),
                hintText: hint,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.yellow)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.white10)),
                // prefixIcon: Padding(
                //   padding: EdgeInsets.only(left: 10, right: 10),
                // child: IconTheme(
                //   data: IconThemeData( color: Colors.white, ),
                //   child: icon,
                // ),
                // )
              ),
            ),
          ]));
    }

    Widget _btnLog(String text, void func()) {
      return ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          func();
          // loadData();
        },
      );
    }

    // Widget _bottomWave() {
    //   return Expanded(
    //     child: Align(
    //       child: ClipPath(
    //         child: Container(
    //           color: Colors.white,
    //           height: 300,
    //         ),
    //         clipper: BottomWaveClipper(),
    //       ),
    //       alignment: Alignment.bottomCenter,
    //     ),
    //   );
    // }

    Widget _form(String label, void func_btn()) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _input(Icon(Icons.email), 'tim@mail.com', _emailController,
                  false, 'Email'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _input(
                  Icon(Icons.lock), 'password', _pwdController, true, 'Пароль'),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: _btnLog(label,
                      func_btn) // _btnLog эта сама кноп которая вызывает действие которая передана через параметр func_btn(пример _registerBtnAction или _loginBtnAction)
                  ),
            ),
          ],
        ),
      );
    }

    void _loginBtnAction() async {
      _emailInputText = _emailController.text;
      _pwdInputText = _pwdController.text;

      if (_emailInputText.isEmpty || _pwdInputText.isEmpty) return;
      AuthUser? user = await _authService.signInWithEmailPassword(
        _emailInputText.trim(),
        _pwdInputText.trim(),
      ); //trim() - обрезать пустые значения
      if (user == null) {
        Fluttertoast.showToast(
            msg: "Can't signIn you! Please check email and password!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            // timeInSecForIosWeb: 1, для ios
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _pwdController.clear();
      }
    }

    void _registerBtnAction() async {
      _emailInputText = _emailController.text;
      _pwdInputText = _pwdController.text;

      if (_emailInputText.isEmpty || _pwdInputText.isEmpty) return;
      AuthUser? user = await _authService.signUpWithEmailPassword(
        _emailInputText.trim(),
        _pwdInputText.trim(),
      ); //trim() - обрезать пустые значения
      if (user == null) {
        Fluttertoast.showToast(
            msg: "Can't Register you! Please check email and password!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            // timeInSecForIosWeb: 1, для ios
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _pwdController.clear();
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          _logo(),
          SizedBox(
            height: 10,
          ),
          (showLogin
              ? Column(
                  children: <Widget>[
                    _form('Войти', _loginBtnAction),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Нету аккаунта? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Зарегистрироваться',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              showLogin = false;
                            });
                          }),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    _form('Зарегистрироваться', _registerBtnAction),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: GestureDetector(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Есть аккаунт?',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  ' Войти',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                          onTap: () {
                            setState(() {
                              showLogin = true;
                            });
                          }),
                    ),
                  ],
                )),
          //  _bottomWave()
        ],
      ),
    );
  }

//   Future<http.Response> getData() async {

//   String username = 'Администратор'; //_emailInputText;
//   String password = '  ';//_pwdInputText;
//   String basicAuth =
//       'Basic ' + base64Encode(utf8.encode('$username:$password'));
//   print(basicAuth);

//   Response r = await get(Uri.parse('http://1c.vct.kz:1998/Demo_buh_Aisana/hs/MobileIntegrate/auth/Администратор/  '), //https://about.google/static/data/locations.json http://1c.vct.kz:1998 - это внешняя сеть, а это  192.168.1.82:8081 - локальная сеть
//       headers: <String, String>{'authorization': basicAuth});

//   return r;

// }

// void loadData(){
//     getData().then((response){
//     if(response.statusCode == 200){
//       print(response.body );
//     }
//     else{
//       print(response.statusCode);
//     }
//   }).catchError((error){
//     debugPrint(error.toString());
//   });
// }
}

// class BottomWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.moveTo(size.width, 0.0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0.0, size.height);
//     path.lineTo(0.0, size.height + 5);
//     var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
//     var secondEndPoint = Offset(size.width, 0.0);
//     path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//         secondEndPoint.dx, secondEndPoint.dy);
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
