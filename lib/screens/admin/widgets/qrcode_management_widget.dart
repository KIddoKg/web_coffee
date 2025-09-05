import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import '../../../services/supabase/qrcode_service.dart';
import '../../../screens/home/model/qrcode_model.dart';
import 'package:xanh_coffee/share/app_imports.dart';

class QRCodeManagementWidget extends StatefulWidget {
  const QRCodeManagementWidget({super.key});

  @override
  State<QRCodeManagementWidget> createState() => _QRCodeManagementWidgetState();
}

class _QRCodeManagementWidgetState extends State<QRCodeManagementWidget> {
  List<QRCodeModel> _qrCodes = [];
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQRCodes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadQRCodes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final qrCodes = await QRCodeService.getAllQRCodes();
      setState(() {
        _qrCodes = qrCodes;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải QR codes: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchQRCodes(String query) async {
    if (query.trim().isEmpty) {
      _loadQRCodes();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final qrCodes = await QRCodeService.searchQRCodes(query.trim());
      setState(() {
        _qrCodes = qrCodes;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tìm kiếm: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteQRCode(int qrCodeId, String linkUrl) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
              'Bạn có chắc chắn muốn xóa QR code "$linkUrl"?\n\nHành động này không thể hoàn tác!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await QRCodeService.deleteQRCode(qrCodeId);
        _showSuccess('Đã xóa QR code "$linkUrl"');
        _loadQRCodes();
      } catch (e) {
        _showError('Lỗi xóa QR code: $e');
      }
    }
  }

  Future<void> _toggleActiveStatus(
      int qrCodeId, bool currentStatus, String linkUrl) async {
    try {
      final newStatus = !currentStatus;
      await QRCodeService.updateQRCode(
        id: qrCodeId,
        isActive: newStatus,
      );

      final statusText = newStatus ? 'bật' : 'tắt';
      _showSuccess('Đã $statusText QR code "$linkUrl"');
      _loadQRCodes();
    } catch (e) {
      _showError('Lỗi cập nhật trạng thái: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
      ),
    );
  }

  void _showQRCodeDetail(QRCodeModel qrCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code #${qrCode.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (qrCode.imageUrl != null && qrCode.imageUrl!.isNotEmpty) ...[
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      qrCode.imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                'Link URL:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(qrCode.linkUrl),
              if (qrCode.color != null && qrCode.color!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Màu:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _parseColor(qrCode.color!),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(qrCode.color!),
                  ],
                ),
              ],
              if (qrCode.createdAt != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Tạo lúc:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(_formatDateTime(qrCode.createdAt!)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: qrCode.linkUrl));
              _showSuccess('Đã copy link vào clipboard');
            },
            child: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        // Parse hex color
        String hex = colorString.substring(1);
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        }
      }

      // Try to parse common color names
      switch (colorString.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'blue':
          return Colors.blue;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        case 'orange':
          return Colors.orange;
        case 'purple':
          return Colors.purple;
        case 'pink':
          return Colors.pink;
        case 'brown':
          return Colors.brown;
        case 'grey':
        case 'gray':
          return Colors.grey;
        case 'black':
          return Colors.black;
        case 'white':
          return Colors.white;
        default:
          return Colors.grey;
      }
    } catch (e) {
      return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý QR Code'),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadQRCodes,
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const AddQRCodeWidget(),
            ),
          );

          if (result == true) {
            _loadQRCodes();
          }
        },
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: AppStyle.padding_LR_16().copyWith(
            left: width < 1200 ? 0 : width * 0.15,
            right: width < 1200 ? 0 : width * 0.15),
        child: Column(
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo link URL...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _loadQRCodes();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
                onChanged: _searchQRCodes,
              ),
            ),

            // Statistics
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code,
                        color: AppStyle.primaryGreen_0_81_49,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tổng số QR codes: ${_qrCodes.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                      color: Colors.red[600],
                    ),
                  ],
                ),
              ),

            // QR Code list
            Expanded(
              child: _buildQRCodeList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải QR codes...'),
          ],
        ),
      );
    }

    if (_qrCodes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Không tìm thấy QR code nào'
                  : 'Chưa có QR code nào',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const AddQRCodeWidget(),
                  ),
                );

                if (result == true) {
                  _loadQRCodes();
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text('Thêm QR code đầu tiên'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primaryGreen_0_81_49,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _qrCodes.length,
      itemBuilder: (context, index) {
        final qrCode = _qrCodes[index];
        return _buildQRCodeCard(qrCode);
      },
    );
  }

  Widget _buildQRCodeCard(QRCodeModel qrCode) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // QR code image or placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: qrCode.imageUrl != null && qrCode.imageUrl!.isNotEmpty
                    ? Image.network(
                        qrCode.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.qr_code,
                              color: Colors.grey,
                              size: 30,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.qr_code,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // QR code info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${qrCode.id}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    qrCode.linkUrl,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (qrCode.color != null && qrCode.color!.isNotEmpty) ...[
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _parseColor(qrCode.color!),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          qrCode.color!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ] else
                        Text(
                          'Không có màu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  if (qrCode.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(qrCode.createdAt!),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                  // Active status
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        qrCode.isActive == true
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 14,
                        color:
                            qrCode.isActive == true ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        qrCode.isActive == true ? 'Hoạt động' : 'Tạm ẩn',
                        style: TextStyle(
                          fontSize: 11,
                          color: qrCode.isActive == true
                              ? Colors.green[600]
                              : Colors.red[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                // Toggle active status button
                IconButton(
                  onPressed: qrCode.id == null
                      ? null
                      : () {
                          _toggleActiveStatus(qrCode.id!,
                              qrCode.isActive == true, qrCode.linkUrl);
                        },
                  icon: Icon(
                    qrCode.isActive == true
                        ? Icons.toggle_on
                        : Icons.toggle_off,
                  ),
                  color: qrCode.isActive == true
                      ? Colors.green[600]
                      : Colors.grey[600],
                  tooltip:
                      qrCode.isActive == true ? 'Tắt QR code' : 'Bật QR code',
                ),

                // View detail button
                IconButton(
                  onPressed: () => _showQRCodeDetail(qrCode),
                  icon: const Icon(Icons.visibility),
                  color: Colors.blue[600],
                  tooltip: 'Xem chi tiết',
                ),

                // Delete button
                IconButton(
                  onPressed: qrCode.id == null
                      ? null
                      : () {
                          _deleteQRCode(qrCode.id!, qrCode.linkUrl);
                        },
                  icon: const Icon(Icons.delete),
                  color: qrCode.id == null ? Colors.grey[400] : Colors.red[600],
                  tooltip: 'Xóa',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget để thêm QR code mới
class AddQRCodeWidget extends StatefulWidget {
  const AddQRCodeWidget({super.key});

  @override
  State<AddQRCodeWidget> createState() => _AddQRCodeWidgetState();
}

class _AddQRCodeWidgetState extends State<AddQRCodeWidget> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();

  bool _isLoading = false;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  Color? _selectedColor;
  bool _isActive = true; // Default to active

  // Predefined colors for color picker
  final List<Color> _predefinedColors = [
    Colors.red,
    Colors.red[300]!,
    Colors.pink,
    Colors.pink[300]!,
    Colors.purple,
    Colors.purple[300]!,
    Colors.deepPurple,
    Colors.deepPurple[300]!,
    Colors.indigo,
    Colors.indigo[300]!,
    Colors.blue,
    Colors.blue[300]!,
    Colors.lightBlue,
    Colors.lightBlue[300]!,
    Colors.cyan,
    Colors.cyan[300]!,
    Colors.teal,
    Colors.teal[300]!,
    Colors.green,
    Colors.green[300]!,
    Colors.lightGreen,
    Colors.lightGreen[300]!,
    Colors.lime,
    Colors.lime[300]!,
    Colors.yellow,
    Colors.yellow[300]!,
    Colors.amber,
    Colors.amber[300]!,
    Colors.orange,
    Colors.orange[300]!,
    Colors.deepOrange,
    Colors.deepOrange[300]!,
    Colors.brown,
    Colors.brown[300]!,
    Colors.grey,
    Colors.grey[400]!,
    Colors.blueGrey,
    Colors.blueGrey[300]!,
    Colors.black,
    Colors.white,
  ];
  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = imageBytes;
          _selectedImageName = image.name;
        });
      }
    } catch (e) {
      _showError('Lỗi chọn ảnh: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageName = null;
    });
  }

  Future<void> _saveQRCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedImageBytes != null && _selectedImageName != null) {
        // Thêm QR code với ảnh
        await QRCodeService.addQRCodeWithImage(
          linkUrl: _linkController.text.trim(),
          fileName: _selectedImageName!,
          fileBytes: _selectedImageBytes!,
          color: _selectedColor != null
              ? '#${_selectedColor!.value.toRadixString(16).substring(2).toUpperCase()}'
              : null,
          isActive: _isActive,
        );
      } else {
        // Thêm QR code không có ảnh
        await QRCodeService.addQRCode(
          linkUrl: _linkController.text.trim(),
          color: _selectedColor != null
              ? '#${_selectedColor!.value.toRadixString(16).substring(2).toUpperCase()}'
              : null,
          isActive: _isActive,
        );
      }
      _showSuccess('Đã thêm QR code thành công!');
      Navigator.of(context).pop(true);
    } catch (e) {
      _showError('Lỗi thêm QR code: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm QR Code'),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: AppStyle.padding_LR_16().copyWith(
            left: width < 1200 ? 0 : width * 0.15,
            right: width < 1200 ? 0 : width * 0.15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Link URL field
                TextFormField(
                  controller: _linkController,
                  decoration: const InputDecoration(
                    labelText: 'Link URL *',
                    hintText: 'https://example.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập link URL';
                    }
                    // Basic URL validation
                    if (!Uri.tryParse(value.trim())!.hasAbsolutePath) {
                      return 'Link URL không hợp lệ';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                // Color picker section
                const Text(
                  'Chọn màu (tuỳ chọn)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Selected color display
                if (_selectedColor != null) ...[
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              '#${_selectedColor!.value.toRadixString(16).substring(2).toUpperCase()}',
                              style: TextStyle(
                                color: _selectedColor!.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedColor = null;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: _selectedColor!.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Color picker grid
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedColor == null
                            ? 'Chọn màu từ bảng màu dưới đây:'
                            : 'Hoặc chọn màu khác:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 20,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: _predefinedColors.length,
                        itemBuilder: (context, index) {
                          final color = _predefinedColors[index];
                          final isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey[300]!,
                                  width: isSelected ? 3 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: color.computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Image section
                const Text(
                  'Ảnh QR Code (tuỳ chọn)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (_selectedImageBytes != null) ...[
                  // Image preview
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _selectedImageBytes!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedImageName ?? 'Ảnh đã chọn',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _removeImage,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Xóa',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ] else ...[
                  // Image picker button
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nhấn để chọn ảnh QR code',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PNG, JPG, JPEG (tối đa 5MB)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Active status switch
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.toggle_on,
                          color: _isActive ? Colors.green : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trạng thái hoạt động',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                _isActive
                                    ? 'QR code sẽ hiển thị công khai'
                                    : 'QR code sẽ bị ẩn',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isActive,
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveQRCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.primaryGreen_0_81_49,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Thêm QR Code',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
