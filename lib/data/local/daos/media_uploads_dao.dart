import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/media_uploads_table.dart';

part 'media_uploads_dao.g.dart';

/// DAO for media uploads
@DriftAccessor(tables: [MediaUploadsTable])
class MediaUploadsDao extends DatabaseAccessor<AppDatabase> with _$MediaUploadsDaoMixin {
  MediaUploadsDao(super.db);

  /// Insert a new upload record
  Future<int> insertUpload(MediaUploadsTableCompanion upload) {
    return into(mediaUploadsTable).insertOnConflictUpdate(upload);
  }

  /// Update upload status
  Future<int> updateUploadStatus(String id, String status) {
    return (update(mediaUploadsTable)..where((u) => u.id.equals(id))).write(
      MediaUploadsTableCompanion(
        uploadStatus: Value(UploadStatus.values.byName(status)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Get pending uploads
  Future<List<MediaUploadsTableData>> getPendingUploads() {
    return (select(mediaUploadsTable)
          ..where((u) => u.uploadStatus.equals(UploadStatus.pending.name) |
              u.uploadStatus.equals(UploadStatus.uploading.name))
          ..orderBy([(u) => OrderingTerm.asc(u.createdAt)]))
        .get();
  }

  /// Delete an upload record
  Future<int> deleteUpload(String id) {
    return (delete(mediaUploadsTable)..where((u) => u.id.equals(id))).go();
  }
}