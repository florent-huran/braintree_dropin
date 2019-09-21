import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:braintree_dropin/braintree_dropin.dart';

void main() {
  const MethodChannel channel = MethodChannel('braintree_dropin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await BraintreeDropin.platformVersion, '42');
  });
}
