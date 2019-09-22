import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/services.dart';

class BraintreeDropin {
  static const MethodChannel _channel = const MethodChannel('braintree_dropin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> showDropIn({String nonce = "",
    String amount = "",
    bool enableGooglePay = false,
    bool inSandbox = true,
    String googleMerchantId = "",
    String clientEmail = "",
    String merchantName = "",
    String currencyCode = "EUR",
    bool useVaultManager = false,
    /*BraintreeDropinAppearance appearance*/
  }) async {
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
        result = await _channel.invokeMethod('showDropIn', {
          'clientToken': nonce,
          'amount': amount,
          'enableGooglePay': enableGooglePay,
          'inSandbox': inSandbox,
          'googleMerchantId': googleMerchantId,
          'email': clientEmail,
          "merchantName": merchantName,
          "currencyCode": currencyCode,
          "vaultManager": useVaultManager
        });
      } else if (inSandbox) {
        result = await _channel.invokeMethod('showDropIn', {
          'clientToken': nonce,
          'amount': amount,
          'inSandbox': inSandbox,
          'enableGooglePay': enableGooglePay,
          'googleMerchantId': googleMerchantId,
          'email': clientEmail,
          "merchantName": merchantName,
          "currencyCode": currencyCode,
          "vaultManager": useVaultManager
        });
      }
      return result;
    } else {
      String result = await _channel.invokeMethod('showDropIn', {
        'clientToken': nonce,
        'amount': amount,
        'clientEmail': clientEmail,
        "merchantName": merchantName,
        /*"appearance": appearance.toJSON()*/
        "vaultManager": useVaultManager
      });
      return result;
    }
  }
}

class BraintreeDropinAppearance {
  /**
   * If variable name is follow by:
   *  - Hex: fill it with an hexadecimal color like #000000
   *  - RawValue: fill it with the associated RawValue of the enum (mostly an int indicating the position of declaration)
   *  See apple documentations and https://github.com/braintree/braintree-ios-drop-in/blob/master/BraintreeUIKit/Public/BTUIKAppearance.h
   *  to have more information about the expected types
   *
   *  SADLY, I wasn't able to find any customization option for Android.
   */

  /// Set theme to dark or light
  bool isDarkTheme;

  /// If true, 'isDarkTheme' will be overrided to match current system theme (available from iOS13)
  bool useSystemTheme;

  /// Fallback color for the overlay if blur is disabled
  String overlayColorHex;

  /// Tint color
  String tintColorHex;

  /// Bar color
  String barBackgroundColorHex;

  /// Font family
  //String fontFamily;

  /// Bold font family
  //String boldFontFamily;

  /// Sheet background color
  String formBackgroundColorHex;

  /// Form field background color
  String formFieldBackgroundColorHex;

  /// Primary text color
  String primaryTextColorHex;

  /// Navigation title text color
  /// Defaults to nil. When not set, navigation titles will use primaryTextColor
  String navigationBarTitleTextColorHex;

  /// Secondary text color
  String secondaryTextColorHex;

  /// Color of disabled buttons
  String disabledColorHex;

  /// Placeholder text color for form fields
  String placeholderTextColorHex;

  /// Line and border color
  String lineColorHex;

  /// Error foreground color
  String errorForegroundColorHex;

  /// Blur style
  String blurStyleRawValue;

  /// Activity indicator style
  String activityIndicatorViewStyleRawValue;

  /// Toggle blur effects
  bool useBlurs;

  /// Tint color for UISwitch when in the on position
  String switchOnTintColorHex;

  /// Tint color for UISwitch thumb
  String switchThumbTintColorHex;

  BraintreeDropinAppearance({
    this.isDarkTheme,
    this.useSystemTheme,
    this.overlayColorHex,
    this.tintColorHex,
    this.barBackgroundColorHex,
    //this.fontFamily,
    //this.boldFontFamily,
    this.formBackgroundColorHex,
    this.formFieldBackgroundColorHex,
    this.primaryTextColorHex,
    this.navigationBarTitleTextColorHex,
    this.secondaryTextColorHex,
    this.disabledColorHex,
    this.placeholderTextColorHex,
    this.lineColorHex,
    this.errorForegroundColorHex,
    this.blurStyleRawValue,
    this.activityIndicatorViewStyleRawValue,
    this.useBlurs,
    this.switchOnTintColorHex,
    this.switchThumbTintColorHex});

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> results = {
      "isDarkTheme": this.isDarkTheme,
      "useSystemTheme": this.useSystemTheme,
      "overlayColorHex": this.overlayColorHex,
      "tintColorHex": this.tintColorHex,
      "barBackgroundColorHex": this.barBackgroundColorHex,
      //"fontFamily": this.fontFamily,
      //"boldFontFamily": this.boldFontFamily,
      "formBackgroundColorHex": this.formBackgroundColorHex,
      "formFieldBackgroundColorHex": this.formFieldBackgroundColorHex,
      "primaryTextColorHex": this.primaryTextColorHex,
      "navigationBarTitleTextColorHex": this.navigationBarTitleTextColorHex,
      "secondaryTextColorHex": this.secondaryTextColorHex,
      "disabledColorHex": this.disabledColorHex,
      "placeholderTextColorHex": this.placeholderTextColorHex,
      "lineColorHex": this.lineColorHex,
      "errorForegroundColorHex": this.errorForegroundColorHex,
      "blurStyleRawValue": this.blurStyleRawValue,
      "activityIndicatorViewStyleRawValue": this
          .activityIndicatorViewStyleRawValue,
      "useBlurs": this.useBlurs,
      "switchOnTintColorHex": this.switchOnTintColorHex,
      "switchThumbTintColorHex": this.switchThumbTintColorHex,
    };
    results.removeWhere((_, element) => element == null);
    return results;
  }

}
