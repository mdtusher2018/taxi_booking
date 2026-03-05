import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/role/common/featured/setting/controller/static_contents.dart';
import 'package:taxi_booking/role/common/featured/setting/model/privacy_policy_model.dart';

class AboutUsView extends ConsumerStatefulWidget {
  const AboutUsView({super.key});

  @override
  ConsumerState<AboutUsView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends ConsumerState<AboutUsView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(staticContentsControllerProvider.notifier).getAboutUs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staticContentsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: CustomText(title: 'About Us', fontSize: 21),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(staticContentsControllerProvider.notifier)
              .getAboutUs();
        },
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
          data: (response) {
            if (response == null) {
              return Center(child: CircularProgressIndicator());
            }
            if ((response as StaticContentResponse).description.isEmpty) {
              return const Center(child: Text('No About info found'));
            }

            final content = response.description;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Html(
                data: content, // ✅ REAL DATA
                style: {
                  "body": Style(
                    fontSize: FontSize.medium,
                    lineHeight: LineHeight.number(1.5),
                  ),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
