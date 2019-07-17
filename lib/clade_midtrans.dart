import 'dart:async';

import 'package:flutter/services.dart';

class CladeMidtrans {
  static const MethodChannel _channel =
  const MethodChannel('ventures.clade.midtrans');


  CladeMidtrans() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Function onTransactionFinished;

  MidtransTransactionStatus _convertFromString(String result) {
    switch (result) {
      case "success":
        return MidtransTransactionStatus.Success;
      case "pending":
        return MidtransTransactionStatus.Pending;
      case "invalid": // unused on ios
        return MidtransTransactionStatus.Invalid;
      case "failed":
        return MidtransTransactionStatus.Failed;
      case "cancelled":
        return MidtransTransactionStatus.Cancelled;
      default:
        throw UnimplementedError("Unknown transaction result status: $result");
    }
  }
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onTransactionFinished":
        if (onTransactionFinished != null) {
          onTransactionFinished(_convertFromString(call.arguments));
        }
        break;
    }
  }

  //Native Method Callback END
  //Native Method Call START

  /// [isSandbox] only used on iOS
  Future initMidtransSdk(String clientKey, String baseUrl,
      {bool isSandbox = false}) async {
    var param = <String, dynamic>{
      'clientKey': clientKey,
      'baseUrl': baseUrl,
      'isSandbox': isSandbox
    };
    await _channel.invokeMethod('initMidtransSdk', param);
  }

  Future setUserDetail(UserDetailMidtrans userDetail) async {
    var userMap = Map<String, String>()
      ..["fullName"] = userDetail.userFullName
      ..["email"] = userDetail.email
      ..["phoneNumber"] = userDetail.phoneNumber
      ..["userId"] = userDetail.userId
      ..["address"] = userDetail.address
      ..["city"] = userDetail.city
      ..["zipCode"] = userDetail.zipCode
      ..["country"] = userDetail.country;
    await _channel.invokeMethod(
        "setUserDetail", <String, Map<String, String>>{'userMap': userMap});
  }

  Future addItemDetail(ItemDetailMidtrans item) async {
    var param = <String, dynamic>{
      'id': item.id,
      'price': item.price,
      'quantity': item.quantity,
      'name': item.name
    };
    await _channel.invokeMethod('addItemDetail', param);
  }

  Future setTransactionRequest(String transactionId, double totalAmount) async {
    var param = <String, dynamic>{
      'transactionId': transactionId,
      'totalAmount': totalAmount
    };
    await _channel.invokeMethod('setTransactionRequest', param);
  }

  Future startPayment(
      {MidtransPaymentMethod paymentMethod,
        String snapToken,
        bool skipCustomerDetails = true}) async {
    var param = <String, dynamic>{
      'skipCustomerDetails': skipCustomerDetails,
    };
    if (snapToken != null && snapToken.isNotEmpty) {
      param['snapToken'] = snapToken;
    }

    if (paymentMethod != null) {
      param['paymentMethod'] = paymentMethod.index;
      await _channel.invokeMethod('startPaymentWithSpecificMethod', param);
    } else {
      await _channel.invokeMethod('startPayment', param);
    }
  }

///Native Method Call END///

}


class UserDetailMidtrans {
  String userFullName;
  String email;
  String phoneNumber;
  String userId;
  String address;
  String city;
  String zipCode;
  String country;
}

class ItemDetailMidtrans {
  String id;
  double price;
  int quantity;
  String name;
}

/// follow midtrans payment method enum's order
enum MidtransPaymentMethod {
  CreditCard,
  BankTransfer,
  BankTransferBca,
  BankTransferMandiri,
  BankTransferPermata,
  BankTransferBni,
  BankTransferOther,
  GoPay,
  BcaKlikPay,
  KlikBca,
  MandiriClickPay,
  MandiriECash,
  EPayBri,
  CimbClicks,
  Indomaret,
  Kioson,
  GiftCardIndonesia,
  IndosatDompetku,
  TelkomselCash,
  XlTunai,
  DanamonOnline
}

enum MidtransTransactionStatus { Success, Pending, Invalid, Failed, Cancelled }
