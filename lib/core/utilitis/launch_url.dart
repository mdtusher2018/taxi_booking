import 'package:url_launcher/url_launcher.dart';

class LaunchUrlService {
  Future<void> makePhoneCall({required String phoneNumber}) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
