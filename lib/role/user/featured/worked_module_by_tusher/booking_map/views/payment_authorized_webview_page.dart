import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/utilitis/enum/payment_status_enums.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String checkoutUrl;

  const PaymentWebViewPage({super.key, required this.checkoutUrl});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
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
              Navigator.pop(context, PaymentResult.success);
              return NavigationDecision.prevent;
            }

            if (url.contains("payment-failed")) {
              Navigator.pop(context, PaymentResult.failed);
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
        title: const Text("Payment"),
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
