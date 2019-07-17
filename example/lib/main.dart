import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:clade_midtrans/clade_midtrans.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final flutterWrapper = CladeMidtrans();

  @override
  void initState() {
    super.initState();
    _initSdk();
  }

  void _initSdk() {
    flutterWrapper.onTransactionFinished = (MidtransTransactionStatus status) {
      debugPrint('DART: TRX FINISHED');
      debugPrint('TRX FINISHED with status: $status');

      switch (status) {
        case MidtransTransactionStatus.Success:
          debugPrint('Transaction success!');
          break;
        case MidtransTransactionStatus.Pending:
          debugPrint('Transaction status pending');
          break;
        case MidtransTransactionStatus.Invalid:
          debugPrint('Transaction Invalid');
          break;
        case MidtransTransactionStatus.Failed:
          debugPrint('Payment Failed');
          break;
        case MidtransTransactionStatus.Cancelled:
          debugPrint('User cancelling payment flow');
          break;
      }
    };

    flutterWrapper.initMidtransSdk(
       'Mid-client-OwCg54VkH2B7y_Bzr', 'https://development.musteat.id/api/midtrans/',
        isSandbox: true);
  }

  void _setUserDetail()async {
    var userDetail = UserDetailMidtrans()
      ..userFullName = 'Edi Kurniawan'
      ..email = 'edi@clade.ventures'
      ..phoneNumber = '085642990808'
      ..address = 'Tangerang'
      ..city = 'Tangerang'
      ..zipCode = '12345'
      ..country = 'Indonesia';
    await flutterWrapper.setUserDetail(userDetail);
  }

  void _addItemDetail() async{
    var itemDetail = ItemDetailMidtrans()
      ..id = '123'
      ..price = 20000.0
      ..quantity = 2
      ..name = 'Dummy Item';
    await flutterWrapper.addItemDetail(itemDetail);
  }

  void _createTransaction() async{
    await flutterWrapper.setTransactionRequest('TRX100009', 40000.0);
  }

  void _startPayment() {
    flutterWrapper.startPayment();
  }

  void _startPaymentWithUserDetail() {
    flutterWrapper.startPayment(skipCustomerDetails: false);
  }

  var snapToken = '34df554e-5250-4b37-b2f9-3c213a398007';

  void _startPaymentWithToken() async {
    await flutterWrapper.startPayment(paymentMethod: MidtransPaymentMethod.GoPay,snapToken: snapToken);
  }

  void _startBankTransferPaymentWithToken() async {
    await flutterWrapper.startPayment(
        paymentMethod: MidtransPaymentMethod.BankTransferPermata,
        snapToken: snapToken);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: Column(
            children: <Widget>[
              /// Temporary disabled
              RaisedButton(
                child: Text('Set User Detail'),
                onPressed: _setUserDetail,
              ),
              RaisedButton(
                child: Text('Add Item Detail'),
                onPressed: _addItemDetail,
              ),
              RaisedButton(
                child: Text('Create Transaction'),
                onPressed: _createTransaction,
              ),
              RaisedButton(
                child: Text('Start Payment'),
                onPressed: _startPayment,
              ),
              RaisedButton(
                child: Text('Start Payment With User Detail'),
                onPressed: _startPaymentWithUserDetail,
              ),
              RaisedButton(
                child: Text('Start SNAP Payment'),
                onPressed: _startPaymentWithToken,
              ),
              RaisedButton(
                child: Text('Start SNAP Payment Direct Bank'),
                onPressed: _startBankTransferPaymentWithToken,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
