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
      "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJleUowZVhBaU9pSktWMVFpTENKaGJHY2lPaUpGVXpJMU5pSXNJbXRwWkNJNklqSXdNVGd3TkRJMk1UWXRjMkZ1WkdKdmVDSjkuZXlKbGVIQWlPakUxTmpreE5qWTFNVFVzSW1wMGFTSTZJalF4T1dRNE5UUmlMV016Wm1VdE5HRTROUzA1WWpnNExUY3dZemRqTkdNM1lqTTNaaUlzSW5OMVlpSTZJbkZ1TkRkdVpHNTZPVGQ0T1hSbk0yNGlMQ0pwYzNNaU9pSkJkWFJvZVNJc0ltMWxjbU5vWVc1MElqcDdJbkIxWW14cFkxOXBaQ0k2SW5GdU5EZHVaRzU2T1RkNE9YUm5NMjRpTENKMlpYSnBabmxmWTJGeVpGOWllVjlrWldaaGRXeDBJanBtWVd4elpYMHNJbkpwWjJoMGN5STZXeUp0WVc1aFoyVmZkbUYxYkhRaVhTd2liM0IwYVc5dWN5STZlMzE5LjVISEFFaVJ4LVJfWmZ4ODVSOWtWYlJEaGFOWnZGOUQ0SlNkWlFteEpZV05pa1FELVU2Q01KZkFGMTNwUC05SDVLV25xbWJDLVRTSWpPb0RNMXZfSEVnIiwiY29uZmlnVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL3FuNDduZG56OTd4OXRnM24vY2xpZW50X2FwaS92MS9jb25maWd1cmF0aW9uIiwiZ3JhcGhRTCI6eyJ1cmwiOiJodHRwczovL3BheW1lbnRzLnNhbmRib3guYnJhaW50cmVlLWFwaS5jb20vZ3JhcGhxbCIsImRhdGUiOiIyMDE4LTA1LTA4In0sImNoYWxsZW5nZXMiOlsiY3Z2Il0sImVudmlyb25tZW50Ijoic2FuZGJveCIsImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy9xbjQ3bmRuejk3eDl0ZzNuL2NsaWVudF9hcGkiLCJhc3NldHNVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImF1dGhVcmwiOiJodHRwczovL2F1dGgudmVubW8uc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFuYWx5dGljcyI6eyJ1cmwiOiJodHRwczovL29yaWdpbi1hbmFseXRpY3Mtc2FuZC5zYW5kYm94LmJyYWludHJlZS1hcGkuY29tL3FuNDduZG56OTd4OXRnM24ifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiTXlzdGVyeVRlYSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6Im15c3Rlcnl0ZWEiLCJjdXJyZW5jeUlzb0NvZGUiOiJFVVIifSwibWVyY2hhbnRJZCI6InFuNDduZG56OTd4OXRnM24iLCJ2ZW5tbyI6Im9mZiIsImFwcGxlUGF5Ijp7InN0YXR1cyI6Im1vY2siLCJjb3VudHJ5Q29kZSI6IlVTIiwiY3VycmVuY3lDb2RlIjoiRVVSIiwibWVyY2hhbnRJZGVudGlmaWVyIjoibWVyY2hhbnQuY29tLm15c3Rlcnl0ZWEuZmx1dHRlciIsInN1cHBvcnRlZE5ldHdvcmtzIjpbInZpc2EiLCJtYXN0ZXJjYXJkIl19fQ==";

  payNow() async {
    BraintreeDropin braintreePayment = new BraintreeDropin();
    var data = await braintreePayment.showDropIn(
        nonce: clientNonce,
        amount: "2.0",
        enableGooglePay: true,
        clientEmail: "test@gmail.com",
        googleMerchantId: "118692457",
        merchantName: "MysteryTea",
        appearance: BraintreeDropinAppearance(
          isDarkTheme: true,
        ));
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
