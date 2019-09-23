## Baintree Dropin v1.0.0

This Flutter package allows you to use the native drop in from Braintree (iOS and Android) in your Flutter projects with a really simple installation.



Currently it supports:

📱iOS v9.0 or newer

🤖 Android API 24 or newer

💵 Credit cards

🇺🇸 Paypal payment

🍎 Apple Pay

📳 Google Pay (not fully tested)

🔐 3DS1 and 3DS2 fully implemented



Let me guide you through the installation process



### Prerequesites

You must have a Braintree account to accept payments.

You can create one by [clicking here](https://signups.braintreepayments.com/?refer=16d5d47612b1618-0ba22552a07a128-3e636e4a-1aeaa0-16d5d47612c1524) or create a sandbox one by [clicking here](https://sandbox.braintreegateway.com/login)



When you have your account, you must setup your server to return you a client nonce and to confirm the payment. The documentation is available [here](https://developers.braintreepayments.com/start/hello-server/node)



When your server is ready, you will be able to use this library in your project



If you want to show Google Pay to your customers, you'll have to get a merchant ID from your Google Merchant Center.



### Setting up Android

You'll have to edit your `AndroidManifest.xml` in order to prepare for Braintree integration and 3DS2.



1. Add the tools declaration in your manifest header :

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="your.package.name"
    xmlns:tools="http://schemas.android.com/tools">
```



2. Add the tools:replace for application label. This prevents Braintree's 3DS partner to raise an error when trying to override your application label:

```xml
<application
        android:name="io.flutter.app.FlutterApplication"
        android:label="Your application name"
        android:ion="@mipmap/ic_launcher"
        tools:replace="android:label">
```



3. Add Braintree's activity to your manifest. The android scheme must not contain any underscore or redirection will fail:

```xml
<activity android:name="com.braintreepayments.api.BraintreeBrowserSwitchActivity"
            android:launchMode="singleTask">
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="mysterytea.mysterytea.braintree" />
            </intent-filter>
        </activity>
```



That's it. Your application is now ready to handle 3DSecure without any fear !



### Setting up iOS

Steps to handle 3DSecure on iOS are a little bit different:



1. Click on your project in the files list on your right. Select Target `Runner` --> `Info` --> `URL Types` 

   Extract from Braintree's documentation:

   Under **URL Types**, enter your app switch return URL scheme. This scheme **must start with your app's Bundle ID and be dedicated to Braintree app switch returns**. For example, if the app bundle ID is `com.your-company.Your-App`, then your URL scheme could be `com.your-company.Your-App.payments`



2. Open your `AppDelegate.swift` file and:

   1. 

   2. ```
      import Braintree
      ```

   2.  Add the following code in your `didFinishLaunchingWithOptions` 

      ```swift
      BTAppSwitch.setReturnURLScheme("the.url.defined.on.step.one")
      ```

   3. Implement the following method:

      ```swift
      override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
              if url.scheme?.localizedCaseInsensitiveCompare("mysterytea.mysterytea.payment") == .orderedSame {
                  return BTAppSwitch.handleOpen(url, options: options)
              }
              return false
          }
      ```



That's it. You're ready too to handle 3DSecure payments in your application.



### Using Braintree Dropin

Now that your server is ready, and your Android and iOS implementations are read, you're ready to go with Braintree Drop In!



First, you'll have to fetch for a client nonce from your server.



Now that you have your client nonce, you can create a method (I called it `showPopin()`), that'll be in charge of displaying the Braintree DropIn and waiting for its data:



```swift
void showPopin(String clientNonce, String clientEmail, String amount) async {
    BraintreeDropin braintreeDropin = new BraintreeDropin();
    var data = await braintreeDropin.showDropIn(
        nonce: clientNonce,
        amount: amount,
        enableGooglePay: true,
        inSandbox: true,
        clientEmail: clientEmail,
        merchantName: "MysteryTea",
        googleMerchantId: null,
        useVaultManager: true);

    if (data == "error") {
      // Display an error to the user
    } else if (data == "cancelled") {
      // Handle dropin cancel by user
    } else {
      sendPaymentToBackEnd(data, amount);
    }
  }
```



Please note: `useVaultManager` allows you to show your customer his last payment methods. However, in order for it to work, you have to precise a curstomer id when you request your `clientNonce` from your server. See Braintree documentation about it if needed.

If success, the returned data will be a String containing a payment nonce.

You're now in charge of sending it to your server in order to capture the payment, and then handling the success or the potential errors from your server.



### Conclusion

As you may have seen, it's incredibly easy to support Braintree payment methods in your application with this library.



I was inspired by [this library](https://github.com/DeligenceTechnologies/Braintree-Payment-Gateway-for-Flutter) that doesn't support 3DS2. That library and this one are both carbon copy of the [Braintree Documentation](https://developers.braintreepayments.com). Don't hesitate to check it if you wonder how things are made.



### To do

Initially planned, the customization feature on iOS has been dropped since v1.0.0 because of unpredictable behaviour. Some more work is needed on our side in order to implement it correctly. PR is welcome !



3DS authorization is happier the more informations about the client it has. For v1.0.0, we only set as necessary the client email. Have in mind that in future versions, you'll be able to set more informations about your client.



Google Pay hasn't be fully tested out. If you have issue with it, please open an issue or do a PR if you have the solution.



Tests are not written at this point