import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future<Uri> createDynamicLinkForProduct(
      bool isShortLink, String tokenShareUrl) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://payrightsystem.page.link/',
      link:
          Uri.parse('https://payrightsystem.page.link/shareurl/$tokenShareUrl'),
      androidParameters: AndroidParameters(
        packageName: 'com.payrightsystem.new_absensi',
        minimumVersion: 1,
      ),
      // iosParameters: IosParameters(
      //   bundleId: 'com.payrightsystem.new_absensi',
      //   minimumVersion: '1',
      //   appStoreId: 'your_app_store_id',
      // ),
    );

    //short link
    Uri dynamicUrl;
    if (isShortLink) {
      final ShortDynamicLink shortDynamicLink =
          await parameters.buildShortLink();
      dynamicUrl = shortDynamicLink.shortUrl;
    } else {
      dynamicUrl = await parameters.buildUrl();
    }
    return dynamicUrl;
  }
}
