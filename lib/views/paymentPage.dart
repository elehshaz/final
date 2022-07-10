import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants.dart';
import '../models/user.dart';

class PaymentPage extends StatefulWidget {
  final User user;
  final double totalpayable;

  const PaymentPage({Key? key, required this.user, required this.totalpayable})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: CONSTANTS.server +
                    '/mytutor/mobile/php/payment.php?email=' +
                    '&mobile=' +
                    widget.user.phoneno.toString() +
                    '&name=' +
                    widget.user.name.toString() +
                    '&amount=' +
                    widget.totalpayable.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
