import 'package:flutter/material.dart';

class CustomerSupportView extends StatelessWidget {
  const CustomerSupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomerSupportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CustomerSupportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
