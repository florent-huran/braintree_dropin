import 'package:flutter/material.dart';
import 'package:braintree_dropin/braintree_dropin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barintree payment',
      theme: ThemeData(primaryColor: Colors.teal),
      home: Pay(),
    );
  }
}

class Pay extends StatefulWidget {
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  String clientNonce =
      "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJleUowZVhBaU9pSktWMVFpTENKaGJHY2lPaUpGVXpJMU5pSXNJbXRwWkNJNklqSXdNVGd3TkRJMk1UWXRjMkZ1WkdKdmVDSjkuZXlKbGVIQWlPakUxTmpreU5UUTROaklzSW1wMGFTSTZJamd5WWpnME5ESmxMV0prTURBdE5HTm1OQzA0WkRVNExXWXdOV0l3TldNME9HTmpZU0lzSW5OMVlpSTZJbkZ1TkRkdVpHNTZPVGQ0T1hSbk0yNGlMQ0pwYzNNaU9pSkJkWFJvZVNJc0ltMWxjbU5vWVc1MElqcDdJbkIxWW14cFkxOXBaQ0k2SW5GdU5EZHVaRzU2T1RkNE9YUm5NMjRpTENKMlpYSnBabmxmWTJGeVpGOWllVjlrWldaaGRXeDBJanAwY25WbGZTd2ljbWxuYUhSeklqcGJJbTFoYm1GblpWOTJZWFZzZENKZExDSnZjSFJwYjI1eklqcDdmWDAubjhqaHQ4aWVvZ3gtNG5rY1VSaVJJeDRxcmozcDUtZnQ3ZU5FU25CVExFejl0TVJuLVVSeDUxM2o3LWhPOHpueUpGbVctOTA5a2syQWd0ZGFscmFEcEEiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvcW40N25kbno5N3g5dGczbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJncmFwaFFMIjp7InVybCI6Imh0dHBzOi8vcGF5bWVudHMuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbS9ncmFwaHFsIiwiZGF0ZSI6IjIwMTgtMDUtMDgifSwiY2hhbGxlbmdlcyI6WyJjdnYiXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL3FuNDduZG56OTd4OXRnM24vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vb3JpZ2luLWFuYWx5dGljcy1zYW5kLnNhbmRib3guYnJhaW50cmVlLWFwaS5jb20vcW40N25kbno5N3g5dGczbiJ9LCJ0aHJlZURTZWN1cmVFbmFibGVkIjp0cnVlLCJwYXlwYWxFbmFibGVkIjp0cnVlLCJwYXlwYWwiOnsiZGlzcGxheU5hbWUiOiJNeXN0ZXJ5VGVhIiwiY2xpZW50SWQiOm51bGwsInByaXZhY3lVcmwiOiJodHRwOi8vZXhhbXBsZS5jb20vcHAiLCJ1c2VyQWdyZWVtZW50VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3RvcyIsImJhc2VVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFzc2V0c1VybCI6Imh0dHBzOi8vY2hlY2tvdXQucGF5cGFsLmNvbSIsImRpcmVjdEJhc2VVcmwiOm51bGwsImFsbG93SHR0cCI6dHJ1ZSwiZW52aXJvbm1lbnROb05ldHdvcmsiOnRydWUsImVudmlyb25tZW50Ijoib2ZmbGluZSIsInVudmV0dGVkTWVyY2hhbnQiOmZhbHNlLCJicmFpbnRyZWVDbGllbnRJZCI6Im1hc3RlcmNsaWVudDMiLCJiaWxsaW5nQWdyZWVtZW50c0VuYWJsZWQiOnRydWUsIm1lcmNoYW50QWNjb3VudElkIjoibXlzdGVyeXRlYSIsImN1cnJlbmN5SXNvQ29kZSI6IkVVUiJ9LCJtZXJjaGFudElkIjoicW40N25kbno5N3g5dGczbiIsInZlbm1vIjoib2ZmIiwiYXBwbGVQYXkiOnsic3RhdHVzIjoibW9jayIsImNvdW50cnlDb2RlIjoiVVMiLCJjdXJyZW5jeUNvZGUiOiJFVVIiLCJtZXJjaGFudElkZW50aWZpZXIiOiJtZXJjaGFudC5jb20ubXlzdGVyeXRlYS5mbHV0dGVyIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiXX19";

  payNow() async {
    BraintreeDropin braintreePayment = new BraintreeDropin();
    var data = await braintreePayment.showDropIn(
        nonce: clientNonce,
        amount: "2.0",
        enableGooglePay: true,
        clientEmail: "test@gmail.com",
        googleMerchantId: "118692457",
        merchantName: "MysteryTea",
    useVaultManager: true);
    print("Response of the payment $data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay Now"),
      ),
      body: Center(
        child: FlatButton(
          onPressed: payNow,
          color: Colors.teal,
          child: Text(
            "Pay Now",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
