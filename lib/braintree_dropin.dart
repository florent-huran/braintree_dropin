import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

class BraintreeDropin {
  static const MethodChannel _channel =
      const MethodChannel('braintree_dropin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future showDropIn({
    @required String nonce,
    @required String amount,
    bool enableGooglePay = false,
    bool inSandbox = false,
    @required String googleMerchantId,
    @required String clientEmail,
    @required String merchantName}) async {

    if (Platform.isAndroid) {
      var result;
      if (inSandbox == false && googleMerchantId.isEmpty) {
        print(
            "ERROR BRAINTREE PAYMENT : googleMerchantId is required in production evnvironment");
      } else if (nonce.isEmpty) {
        print("ERROR BRAINTREE PAYMENT : Nonce cannot be empty");
      } else if (amount.isEmpty) {
        print("ERROR BRAINTREE PAYMENT : Amount cannot be empty");
      } else if (inSandbox == false && googleMerchantId.isNotEmpty) {
        result = await _channel.invokeMethod<Map>('showDropIn', {
          'clientToken': nonce,
          'amount': amount,
          'enableGooglePay': enableGooglePay,
          'inSandbox': inSandbox,
          'googleMerchantId': googleMerchantId,
          'email': clientEmail,
          "merchantName": merchantName
        });
      } else if (inSandbox) {
        result = await _channel.invokeMethod<Map>('showDropIn', {
          'clientToken': nonce,
          'amount': amount,
          'inSandbox': inSandbox,
          'enableGooglePay': enableGooglePay,
          'googleMerchantId': googleMerchantId,
          'email': clientEmail,
          "merchantName": merchantName
        });
      }
      return result;
    } else {
      String result = await _channel
          .invokeMethod('showDropIn', {'clientToken': nonce, 'amount': amount, 'clientEmail': clientEmail, "merchantName": merchantName});
      return result;
    }

  }
}
