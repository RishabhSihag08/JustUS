import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import 'dart:io';

/// Service for handling media uploads and downloads
class MediaService {
  final SupabaseClient _supabase;

  MediaService(this._supabase);

  /// Upload media file to Supabase Storage
  Future<String?> uploadMedia({
    required File file,
    required String bucket,
    required String path,
    String? contentType,
  }) async {
    try {
      final response = await _supabase.storage.from(bucket).upload(
            path,
            file,
            fileOptions: FileOptions(
              contentType: contentType ?? _getContentType(file.path),
              upsert: false,
            ),
          );

      if (response.isEmpty) return null;

      // Get public URL
      final url = _supabase.storage.from(bucket).getPublicUrl(path);
      return url;
    } catch (e) {
      debugPrint('Error uploading media: $e');
      return null;
    }
  }

  /// Upload compressed image
  Future<String?> uploadImage({
    required File file,
    required String bucket,
    required String path,
    int quality = 80,
    int maxWidth = 1920,
    int maxHeight = 1920,
  }) async {
    try {
      // Read and compress image
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Resize if needed
      final resized = image.width > maxWidth || image.height > maxHeight
          ? img.copyResize(image, width: maxWidth, height: maxHeight)
          : image;

      // Compress
      final compressedBytes = img.encodeJpg(resized, quality: quality);

      // Upload
      final response = await _supabase.storage.from(bucket).uploadBinary(
            path,
            compressedBytes,
            fileOptions: FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );

      if (response.isEmpty) return null;

      final url = _supabase.storage.from(bucket).getPublicUrl(path);
      return url;
    } catch (e) {
      debugPrint('Error uploading compressed image: $e');
      return null;
    }
  }

  /// Upload video (with thumbnail generation)
  Future<VideoUploadResult> uploadVideo({
    required File file,
    required String bucket,
    required String videoPath,
    required String thumbnailPath,
  }) async {
    try {
      // Upload video
      final videoUrl = await uploadMedia(
        file: file,
        bucket: bucket,
        path: videoPath,
        contentType: 'video/mp4',
      );

      // Generate and upload thumbnail
      // Note: In a real app, you'd use a video thumbnail generator
      // For now, we'll skip thumbnail generation

      return VideoUploadResult(videoUrl: videoUrl, thumbnailUrl: null);
    } catch (e) {
      debugPrint('Error uploading video: $e');
      return VideoUploadResult(videoUrl: null, thumbnailUrl: null);
    }
  }

  /// Upload audio/voice note
  Future<String?> uploadAudio({
    required File file,
    required String bucket,
    required String path,
  }) async {
    return uploadMedia(
      file: file,
      bucket: bucket,
      path: path,
      contentType: 'audio/m4a',
    );
  }

  /// Upload document
  Future<String?> uploadDocument({
    required File file,
    required String bucket,
    required String path,
    String? contentType,
  }) async {
    return uploadMedia(
      file: file,
      bucket: bucket,
      path: path,
      contentType: contentType,
    );
  }

  /// Download media file
  Future<Uint8List?> downloadMedia({
    required String bucket,
    required String path,
  }) async {
    try {
      final data = await _supabase.storage.from(bucket).download(path);
      return data;
    } catch (e) {
      debugPrint('Error downloading media: $e');
      return null;
    }
  }

  /// Delete media file
  Future<bool> deleteMedia({
    required String bucket,
    required String path,
  }) async {
    try {
      await _supabase.storage.from(bucket).remove([path]);
      return true;
    } catch (e) {
      debugPrint('Error deleting media: $e');
      return false;
    }
  }

  /// Get signed URL for private bucket access
  Future<String?> getSignedUrl({
    required String bucket,
    required String path,
    int expiresIn = 3600,
  }) async {
    try {
      final url = await _supabase.storage.from(bucket).createSignedUrl(path, expiresIn);
      return url;
    } catch (e) {
      debugPrint('Error creating signed URL: $e');
      return null;
    }
  }

  /// Generate unique file path
  String generateFilePath(String userId, String fileName, String type) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = p.extension(fileName);
    final baseName = p.basenameWithoutExtension(fileName);
    return '$userId/$type/${timestamp}_$baseName$extension';
  }

  /// Get content type from file extension
  String _getContentType(String path) {
    final extension = p.extension(path).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.m4a':
      case '.aac':
        return 'audio/m4a';
      case '.mp3':
        return 'audio/mpeg';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  /// Compress image file
  Future<File?> compressImage(File file, {int quality = 80, int maxWidth = 1920, int maxHeight = 1920}) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final resized = image.width > maxWidth || image.height > maxHeight
          ? img.copyResize(image, width: maxWidth, height: maxHeight)
          : image;

      final compressedBytes = img.encodeJpg(resized, quality: quality);

      final tempDir = Directory.systemTemp;
      final tempFile = File(p.join(tempDir.path, 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg'));
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return null;
    }
  }
}

/// Result class for video upload
class VideoUploadResult {
  final String? videoUrl;
  final String? thumbnailUrl;

  VideoUploadResult({this.videoUrl, this.thumbnailUrl});
}

