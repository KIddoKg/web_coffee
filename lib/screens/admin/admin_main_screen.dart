import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import '../../share/app_styles.dart';
import 'widgets/admin_product_sync_widget.dart';
import 'widgets/product_management_widget.dart';
import 'widgets/category_management_widget.dart';
import 'widgets/feedback_management_widget.dart';
import 'widgets/blog_management_widget.dart';
import 'widgets/qrcode_management_widget.dart';
import 'viewModel/admin_screen_vm.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) { SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;
    return ChangeNotifierProvider(
      create: (_) => AdminScreenVm(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: AppStyle.primaryGreen_0_81_49,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: AppStyle.padding_LR_16().copyWith(
              left: width < 1200 ? 0 : width * 0.15,
              right: width < 1200 ? 0 : width * 0.15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: width < 600 ? 2 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
              children: [
                _buildAdminCard(
                  context,
          
                  title: 'Quản lý Sản phẩm',
                  subtitle: 'Thêm, sửa, xóa sản phẩm',
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductManagementWidget(),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context ,
                  title: 'Quản lý Danh mục',
                  subtitle: 'Thêm, sửa, ẩn danh mục',
                  icon: Icons.category,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CategoryManagementWidget(),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'Quản lý Blog',
                  subtitle: 'Thêm, xóa và sắp xếp bài viết',
                  icon: Icons.article,
                  color: Colors.deepPurple,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BlogManagementWidget(),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'Quản lý Feedback',
                  subtitle: 'Xem và quản lý feedback từ khách hàng',
                  icon: Icons.feedback,
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FeedbackManagementWidget(),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'Quản lý QR Code',
                  subtitle: 'Thêm, xóa QR codes',
                  icon: Icons.qr_code,
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const QRCodeManagementWidget(),
                      ),
                    );
                  },
                ),
                // _buildAdminCard(
                //   context,
                //   title: 'Sync Supabase',
                //   subtitle: 'Đồng bộ dữ liệu với Supabase',
                //   icon: Icons.cloud_sync,
                //   color: AppStyle.primaryGreen_0_81_49,
                //   onTap: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => ChangeNotifierProvider(
                //           create: (_) => AdminScreenVm(),
                //           child: const AdminProductSyncWidget(),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                _buildAdminCard(
                  context,
                  title: 'Thống kê',
                  subtitle: 'Xem thống kê sản phẩm và doanh thu',
                  icon: Icons.analytics,
                  color: Colors.purple,
                  onTap: () {
                    // TODO: Implement statistics screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tính năng thống kê đang được phát triển'),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'Cài đặt',
                  subtitle: 'Cấu hình ứng dụng',
                  icon: Icons.settings,
                  color: Colors.orange,
                  onTap: () {
                    // TODO: Implement settings screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tính năng cài đặt đang được phát triển'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,

  }) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 25,
                  color: color,
                ),
              ),
              if(width > 450)
                Column(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )

            ],
          ),
        ),
      ),
    );
  }
}
