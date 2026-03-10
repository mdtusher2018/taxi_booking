import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/utilitis/enum/payment_status_enums.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeConnectWebViewPage extends StatefulWidget {
  final String checkoutUrl;

  const StripeConnectWebViewPage({super.key, required this.checkoutUrl});

  @override
  State<StripeConnectWebViewPage> createState() =>
      _StripeConnectWebViewPageState();
}

class _StripeConnectWebViewPageState extends State<StripeConnectWebViewPage> {
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

            if (url.contains("confirm")) {
              Navigator.pop(context, StripeResult.success);
              return NavigationDecision.prevent;
            }

            if (url.contains("failed")) {
              Navigator.pop(context, StripeResult.failed);
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
