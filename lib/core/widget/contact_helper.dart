import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactHelper {
  /// Call a phone number directly
  static Future<void> call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (!await launchUrl(uri)) {
      debugPrint('❌ Cannot call: $phone');
    }
  }

  /// Open WhatsApp with a message
  static Future<void> whatsapp(String phone, String msg) async {
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(msg)}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('❌ Cannot open WhatsApp for: $phone');
    }
  }
  static Future<void> openWebsite(String url) async {
    // Add https:// if not present
    String finalUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      finalUrl = 'https://$url';
    }

    final uri = Uri.parse(finalUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('❌ Cannot open website: $url');
    }
  }
}