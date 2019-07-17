import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clade_midtrans/clade_midtrans.dart';

void main() {
  const MethodChannel channel = MethodChannel('clade_midtrans');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

}
