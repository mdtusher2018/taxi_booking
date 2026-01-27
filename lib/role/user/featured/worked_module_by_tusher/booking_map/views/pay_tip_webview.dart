import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/utilitis/enum/payment_status_enums.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayTipWebViewPage extends StatefulWidget {
  final String checkoutUrl;

  const PayTipWebViewPage({super.key, required this.checkoutUrl});

  @override
  State<PayTipWebViewPage> createState() => _PayTipWebViewPageState();
}

class _PayTipWebViewPageState extends State<PayTipWebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            AppLogger.i(url);
            if (url.contains("confirm-payment")) {
              Navigator.pop(context, TipResult.success);
              return NavigationDecision.prevent;
            }

            if (url.contains("payment-failed")) {
              Navigator.pop(context, TipResult.failed);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay Tip"),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: PopScope(
        canPop: false,
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
