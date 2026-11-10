import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Helper service to save chat media (images & videos) directly into the Android device Gallery / MediaStore
class GallerySaverService {
  static const _channel = MethodChannel('com.justus.justus/device_lock');

  /// Save local or remote media to Android Gallery
  static Future<bool> saveToGallery(String mediaPathOrUrl, {String? mimeType}) async {
    try {
      String localFilePath = mediaPathOrUrl;

      // If it's a remote URL, download it to temporary file first
      if (mediaPathOrUrl.startsWith('http://') || mediaPathOrUrl.startsWith('https://')) {
        final downloaded = await _downloadFile(mediaPathOrUrl);
        if (downloaded == null) return false;
        localFilePath = downloaded.path;
      }

      final file = File(localFilePath);
      if (!await file.exists()) {
        debugPrint('GallerySaverService: File does not exist at $localFilePath');
        return false;
      }

      final determinedMime = mimeType ?? _guessMimeType(localFilePath);

      // Invoke native MediaStore channel
      final result = await _channel.invokeMethod<bool>('saveImageToGallery', {
        'filePath': file.absolute.path,
        'mimeType': determinedMime,
      });

      return result ?? false;
    } catch (e) {
      debugPrint('GallerySaverService error: $e');
      return false;
    }
  }

  static String _guessMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.mp4')) return 'video/mp4';
    if (lower.endsWith('.mov')) return 'video/quicktime';
    return 'image/jpeg';
  }

  static Future<File?> _downloadFile(String url) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        return null;
      }

      final bytes = await consolidateHttpClientResponseBytes(response);
      final tempDir = await getTemporaryDirectory();
      final ext = _guessExtension(url);
      final file = File('${tempDir.path}/download_${DateTime.now().millisecondsSinceEpoch}.$ext');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('Download error in GallerySaverService: $e');
      return null;
    }
  }

  static String _guessExtension(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('.png')) return 'png';
    if (lower.contains('.gif')) return 'gif';
    if (lower.contains('.webp')) return 'webp';
    if (lower.contains('.mp4')) return 'mp4';
    return 'jpg';
  }
}
