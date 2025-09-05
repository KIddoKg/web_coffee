import '../screens/home/model/qrcode_model.dart';
import '../services/supabase/qrcode_service.dart';

/// Extension for HomeScreenVm to handle QR Code operations
class QRCodeManager {
  List<QRCodeModel> _qrCodes = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<QRCodeModel> get qrCodes => _qrCodes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all QR codes from database
  Future<void> loadQRCodes() async {
    try {
      _isLoading = true;
      _errorMessage = null;

      _qrCodes = await QRCodeService.getAllQRCodes();

      print('Loaded ${_qrCodes.length} QR codes from database');

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi tải QR codes: $e';
      print(_errorMessage);

      // Set empty list if database fails
      _qrCodes = [];
    }
  }

  /// Get all QR codes
  List<QRCodeModel> getAllQRCodes() {
    return _qrCodes;
  }

  /// Get QR codes by color
  List<QRCodeModel> getQRCodesByColor(String color) {
    return _qrCodes.where((qr) => qr.color == color).toList();
  }

  /// Get QR code by ID
  QRCodeModel? getQRCodeById(int id) {
    try {
      return _qrCodes.firstWhere((qr) => qr.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search QR codes by link URL
  List<QRCodeModel> searchQRCodes(String query) {
    if (query.trim().isEmpty) return _qrCodes;

    final lowerQuery = query.toLowerCase();
    return _qrCodes
        .where((qr) => qr.linkUrl.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get QR codes with images
  List<QRCodeModel> getQRCodesWithImages() {
    return _qrCodes
        .where((qr) => qr.imageUrl != null && qr.imageUrl!.isNotEmpty)
        .toList();
  }

  /// Get QR codes without images
  List<QRCodeModel> getQRCodesWithoutImages() {
    return _qrCodes
        .where((qr) => qr.imageUrl == null || qr.imageUrl!.isEmpty)
        .toList();
  }

  /// Get random QR codes
  List<QRCodeModel> getRandomQRCodes({int limit = 5}) {
    final shuffled = List<QRCodeModel>.from(_qrCodes)..shuffle();
    return shuffled.take(limit).toList();
  }

  /// Get latest QR codes
  List<QRCodeModel> getLatestQRCodes({int limit = 5}) {
    final sorted = List<QRCodeModel>.from(_qrCodes);
    sorted.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return b.createdAt!.compareTo(a.createdAt!);
      }
      return (b.id ?? 0).compareTo(a.id ?? 0);
    });
    return sorted.take(limit).toList();
  }

  /// Get QR codes stats
  Map<String, dynamic> getQRCodeStats() {
    final withImages = getQRCodesWithImages().length;
    final withoutImages = getQRCodesWithoutImages().length;

    // Count by colors
    Map<String, int> colorStats = {};
    for (final qr in _qrCodes) {
      final color = qr.color ?? 'Không màu';
      colorStats[color] = (colorStats[color] ?? 0) + 1;
    }

    return {
      'total': _qrCodes.length,
      'withImages': withImages,
      'withoutImages': withoutImages,
      'colorStats': colorStats,
    };
  }

  /// Refresh QR codes from database
  Future<void> refreshQRCodes() async {
    await loadQRCodes();
  }

  /// Clear all QR codes (local only)
  void clearQRCodes() {
    _qrCodes.clear();
    _errorMessage = null;
  }

  /// Add new QR code to local list (after adding to database)
  void addQRCodeToList(QRCodeModel qrCode) {
    _qrCodes.add(qrCode);
    // Sort by latest first
    _qrCodes.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return b.createdAt!.compareTo(a.createdAt!);
      }
      return (b.id ?? 0).compareTo(a.id ?? 0);
    });
  }

  /// Remove QR code from local list (after deleting from database)
  void removeQRCodeFromList(int qrCodeId) {
    _qrCodes.removeWhere((qr) => qr.id == qrCodeId);
  }

  /// Update QR code in local list (after updating in database)
  void updateQRCodeInList(QRCodeModel updatedQRCode) {
    final index = _qrCodes.indexWhere((qr) => qr.id == updatedQRCode.id);
    if (index != -1) {
      _qrCodes[index] = updatedQRCode;
    }
  }
}
