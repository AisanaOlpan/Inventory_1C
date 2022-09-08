import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';


class ScanPage extends StatefulWidget {
  ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _isInitialized = false;
  List<Barcode> barcodes = [];
  var brCode = '';
  @override 
  void initState() {    
    FlutterMobileVision.start().then((value) {
      setState(() {
        _isInitialized = true;
      });
    });
    super.initState();
  }

  Future <void> ScanBarCode() async {
    try {
      barcodes = await FlutterMobileVision.scan(
        // waitTap:true,
        showText: true,
      );

      if (barcodes.length > 0) {
        //    Navigator.push(context, MaterialPageRoute(builder: ((context) => ProductPage(barcodeText: barcodes[0].displayValue))));
      setState(() {
         brCode = barcodes[0].displayValue;
      });
       
        // for(Barcode barcode in  barcodes){
        //   print('barcodevalueis ${barcode.displayValue} ${barcode.getFormatString()} ${barcode.getValueFormatString()}');
        // }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _btnScan(void func()) {
      return RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Icon(
          Icons.qr_code_scanner_outlined,
          size: 50,
        ),
        color: Colors.white54,
        onPressed: () {
          func();
          // loadData();
        },
      );
    }



    return Scaffold(
        body: Container(
            child: Align(
                alignment: Alignment.center, 
                
                child: Column (children: <Widget> [Text('$brCode'), _btnScan(ScanBarCode)])))
                );
  }
}
