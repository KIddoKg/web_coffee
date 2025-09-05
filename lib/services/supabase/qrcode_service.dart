import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../screens/home/model/qrcode_model.dart';
import 'services_supabase.dart';

class QRCodeService {
  static const String _tableName = 'qrcodes';
  static const String _bucketName = 'product-images'; // Sử dụng bucket chung
  static const String _qrFolderPath = 'qr'; // Folder con cho QR codes

  /// Thêm QR code mới
  static Future<QRCodeModel> addQRCode({
    required String linkUrl,
    String? color,
    String? imageUrl,
    bool isActive = true,
  }) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .insert({
            'color': color,
            'image_url': imageUrl,
            'link_url': linkUrl,
            'is_active': isActive,
          })
          .select()
          .single();

      debugPrint('Thêm QR code thành công: $linkUrl');
      return QRCodeModel.fromJson(response);
    } catch (e) {
      debugPrint('Lỗi thêm QR code: $e');
      rethrow;
    }
  }

  /// Lấy tất cả QR codes
  static Future<List<QRCodeModel>> getAllQRCodes() async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .order('created_at', ascending: false);

      return response
          .map<QRCodeModel>((json) => QRCodeModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Lỗi lấy danh sách QR codes: $e');
      rethrow;
    }
  }

  /// Lấy QR codes theo trạng thái active
  static Future<List<QRCodeModel>> getActiveQRCodes() async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return response
          .map<QRCodeModel>((json) => QRCodeModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Lỗi lấy danh sách QR codes active: $e');
      rethrow;
    }
  }

  /// Lấy QR code theo ID
  static Future<QRCodeModel?> getQRCodeById(int id) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return QRCodeModel.fromJson(response);
    } catch (e) {
      debugPrint('Lỗi lấy QR code theo ID $id: $e');
      rethrow;
    }
  }

  /// Cập nhật QR code
  static Future<QRCodeModel> updateQRCode({
    required int id,
    String? color,
    String? imageUrl,
    String? linkUrl,
    bool? isActive,
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      if (color != null) updateData['color'] = color;
      if (imageUrl != null) updateData['image_url'] = imageUrl;
      if (linkUrl != null) updateData['link_url'] = linkUrl;
      if (isActive != null) updateData['is_active'] = isActive;

      final response = await SupabaseService.from(_tableName)
          .update(updateData)
          .eq('id', id)
          .select()
          .single();

      debugPrint('Cập nhật QR code thành công: ID $id');
      return QRCodeModel.fromJson(response);
    } catch (e) {
      debugPrint('Lỗi cập nhật QR code: $e');
      rethrow;
    }
  }

  /// Xóa QR code
  static Future<void> deleteQRCode(int id) async {
    try {
      // Lấy thông tin QR code trước khi xóa để xóa ảnh
      final qrCode = await getQRCodeById(id);

      // Xóa record từ database
      await SupabaseService.from(_tableName).delete().eq('id', id);

      // Xóa ảnh từ storage nếu có
      if (qrCode?.imageUrl != null && qrCode!.imageUrl!.isNotEmpty) {
        await deleteQRCodeImage(qrCode.imageUrl!);
      }

      debugPrint('Đã xóa QR code thành công: ID $id');
    } catch (e) {
      debugPrint('Lỗi xóa QR code: $e');
      rethrow;
    }
  }

  /// Upload ảnh QR code lên Supabase Storage
  static Future<String> uploadQRCodeImage({
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      final String path =
          '$_qrFolderPath/qr_${DateTime.now().millisecondsSinceEpoch}_$fileName';

      final String imageUrl = await SupabaseService.uploadFile(
        bucket: _bucketName,
        path: path,
        fileBytes: fileBytes,
      );

      debugPrint('Upload QR code image thành công: $imageUrl');
      return imageUrl;
    } catch (e) {
      debugPrint('Lỗi upload QR code image: $e');
      rethrow;
    }
  }

  /// Xóa ảnh QR code từ storage
  static Future<void> deleteQRCodeImage(String imageUrl) async {
    try {
      // Trích xuất path từ URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Path format: /storage/v1/object/public/bucket/path
      if (pathSegments.length >= 3) {
        final path = pathSegments.sublist(2).join('/');
        await SupabaseService.deleteFile(bucket: _bucketName, path: path);
        debugPrint('Xóa QR code image thành công: $path');
      }
    } catch (e) {
      debugPrint('Lỗi xóa QR code image: $e');
      // Không rethrow vì việc xóa ảnh không quan trọng bằng việc xóa record
    }
  }

  /// Tìm kiếm QR codes theo link URL
  static Future<List<QRCodeModel>> searchQRCodes(String query) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .ilike('link_url', '%$query%')
          .order('created_at', ascending: false);

      return response
          .map<QRCodeModel>((json) => QRCodeModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Lỗi tìm kiếm QR codes: $e');
      rethrow;
    }
  }

  /// Lấy QR codes theo màu
  static Future<List<QRCodeModel>> getQRCodesByColor(String color) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .eq('color', color)
          .order('created_at', ascending: false);

      return response
          .map<QRCodeModel>((json) => QRCodeModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Lỗi lấy QR codes theo màu: $e');
      rethrow;
    }
  }

  /// Thêm QR code với upload ảnh
  static Future<QRCodeModel> addQRCodeWithImage({
    required String linkUrl,
    required String fileName,
    required Uint8List fileBytes,
    String? color,
    bool isActive = true,
  }) async {
    try {
      // Upload ảnh trước
      final imageUrl = await uploadQRCodeImage(
        fileName: fileName,
        fileBytes: fileBytes,
      );

      // Tạo QR code với URL ảnh
      return await addQRCode(
        linkUrl: linkUrl,
        color: color,
        imageUrl: imageUrl,
        isActive: isActive,
      );
    } catch (e) {
      debugPrint('Lỗi thêm QR code với ảnh: $e');
      rethrow;
    }
  }

  /// Cập nhật QR code với ảnh mới
  static Future<QRCodeModel> updateQRCodeWithImage({
    required int id,
    required String fileName,
    required Uint8List fileBytes,
    String? color,
    String? linkUrl,
  }) async {
    try {
      // Lấy QR code hiện tại để xóa ảnh cũ
      final currentQRCode = await getQRCodeById(id);

      // Upload ảnh mới
      final imageUrl = await uploadQRCodeImage(
        fileName: fileName,
        fileBytes: fileBytes,
      );

      // Cập nhật QR code
      final updatedQRCode = await updateQRCode(
        id: id,
        color: color,
        imageUrl: imageUrl,
        linkUrl: linkUrl,
      );

      // Xóa ảnh cũ nếu có
      if (currentQRCode?.imageUrl != null &&
          currentQRCode!.imageUrl!.isNotEmpty &&
          currentQRCode.imageUrl != imageUrl) {
        await deleteQRCodeImage(currentQRCode.imageUrl!);
      }

      return updatedQRCode;
    } catch (e) {
      debugPrint('Lỗi cập nhật QR code với ảnh: $e');
      rethrow;
    }
  }

  /// Lấy thống kê QR codes
  static Future<Map<String, dynamic>> getQRCodeStats() async {
    try {
      final qrCodes = await getAllQRCodes();

      // Đếm theo màu
      Map<String, int> colorStats = {};
      int withImage = 0;
      int withoutImage = 0;

      for (final qr in qrCodes) {
        // Thống kê màu
        final color = qr.color ?? 'Không màu';
        colorStats[color] = (colorStats[color] ?? 0) + 1;

        // Thống kê ảnh
        if (qr.imageUrl != null && qr.imageUrl!.isNotEmpty) {
          withImage++;
        } else {
          withoutImage++;
        }
      }

      return {
        'total': qrCodes.length,
        'withImage': withImage,
        'withoutImage': withoutImage,
        'colorStats': colorStats,
      };
    } catch (e) {
      debugPrint('Lỗi lấy thống kê QR codes: $e');
      rethrow;
    }
  }

  /// Xóa tất cả QR codes (dùng để reset)
  static Future<void> clearAllQRCodes() async {
    try {
      // Lấy tất cả QR codes để xóa ảnh
      final qrCodes = await getAllQRCodes();

      // Xóa tất cả ảnh
      for (final qr in qrCodes) {
        if (qr.imageUrl != null && qr.imageUrl!.isNotEmpty) {
          await deleteQRCodeImage(qr.imageUrl!);
        }
      }

      // Xóa tất cả records
      await SupabaseService.from(_tableName).delete().neq('id', 0);

      debugPrint('Đã xóa tất cả QR codes');
    } catch (e) {
      debugPrint('Lỗi xóa tất cả QR codes: $e');
      rethrow;
    }
  }
}
