// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../share/app_styles.dart';
// import '../viewModel/admin_screen_vm.dart';
//
// class AdminProductSyncWidget extends StatefulWidget {
//   const AdminProductSyncWidget({super.key});
//
//   @override
//   State<AdminProductSyncWidget> createState() => _AdminProductSyncWidgetState();
// }
//
// class _AdminProductSyncWidgetState extends State<AdminProductSyncWidget> {
//   @override
//   void initState() {
//     super.initState();
//     // Load dữ liệu từ Supabase khi init
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AdminScreenVm>().loadProductsFromSupabase();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AdminScreenVm>(
//       builder: (context, vm, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Quản lý Sản phẩm - Supabase'),
//             backgroundColor: Colors.brown[600],
//             foregroundColor: Colors.white,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Error message
//                 if (vm.errorMessage != null)
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.red[50],
//                       border: Border.all(color: Colors.red[300]!),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.error, color: Colors.red[600]),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             vm.errorMessage!,
//                             style: TextStyle(color: Colors.red[800]),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: vm.clearError,
//                           icon: const Icon(Icons.close),
//                           color: Colors.red[600],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 // Thông tin thống kê
//                 _buildStatsCard(vm),
//
//                 const SizedBox(height: 16),
//
//                 // Action buttons
//                 _buildActionButtons(context, vm),
//
//                 const SizedBox(height: 16),
//
//                 // Danh sách sản phẩm từ Supabase
//                 Expanded(
//                   child: _buildProductsList(vm),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildStatsCard(AdminScreenVm vm) {
//     final localProductsCount = vm.productsByFilter.values
//         .fold<int>(0, (sum, products) => sum + products.length);
//
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Thống kê',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildStatItem(
//                   'Sản phẩm Local',
//                   localProductsCount.toString(),
//                   Icons.phone_android,
//                   Colors.blue,
//                 ),
//                 _buildStatItem(
//                   'Sản phẩm Supabase',
//                   vm.supabaseProducts.length.toString(),
//                   Icons.cloud,
//                   AppStyle.primaryGreen_0_81_49,
//                 ),
//                 _buildStatItem(
//                   'Categories',
//                   vm.productsByFilter.keys.length.toString(),
//                   Icons.category,
//                   Colors.orange,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatItem(
//       String title, String value, IconData icon, Color color) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 32),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//         ),
//         Text(
//           title,
//           style: Theme.of(context).textTheme.bodySmall,
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons(BuildContext context, AdminScreenVm vm) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Thao tác',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: vm.isSyncingToSupabase || vm.isLoading
//                         ? null
//                         : () => vm.syncProductsToSupabase(),
//                     icon: vm.isSyncingToSupabase
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Icon(Icons.cloud_upload),
//                     label: Text(vm.isSyncingToSupabase
//                         ? 'Đang sync...'
//                         : 'Sync lên Supabase'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppStyle.primaryGreen_0_81_49,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: vm.isLoading || vm.isSyncingToSupabase
//                         ? null
//                         : () => vm.loadProductsFromSupabase(),
//                     icon: vm.isLoading
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Icon(Icons.refresh),
//                     label: Text(vm.isLoading ? 'Đang tải...' : 'Tải lại'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[600],
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: vm.isLoading || vm.isSyncingToSupabase
//                     ? null
//                     : () => _showClearConfirmDialog(context, vm),
//                 icon: const Icon(Icons.delete_forever),
//                 label: const Text('Xóa tất cả sản phẩm Supabase'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red[600],
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductsList(AdminScreenVm vm) {
//     if (vm.isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text('Đang tải sản phẩm từ Supabase...'),
//           ],
//         ),
//       );
//     }
//
//     if (vm.supabaseProducts.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.inbox, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text('Chưa có sản phẩm nào trên Supabase'),
//             SizedBox(height: 8),
//             Text('Nhấn "Sync lên Supabase" để đồng bộ dữ liệu'),
//           ],
//         ),
//       );
//     }
//
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               'Sản phẩm trên Supabase (${vm.supabaseProducts.length})',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: vm.supabaseProducts.length,
//               itemBuilder: (context, index) {
//                 final product = vm.supabaseProducts[index];
//                 return ListTile(
//                   leading: product['image_url'] != null
//                       ? CircleAvatar(
//                           backgroundImage: NetworkImage(product['image_url']),
//                           onBackgroundImageError: (_, __) {},
//                         )
//                       : const CircleAvatar(
//                           child: Icon(Icons.coffee),
//                         ),
//                   title: Text(product['name'] ?? 'N/A'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Giá: ${product['price']}đ'),
//                       Text('Category: ${product['category'] ?? 'N/A'}'),
//                       if (product['is_best_seller'] == true)
//                         const Text(
//                           'Best Seller',
//                           style: TextStyle(
//                             color: Colors.orange,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                     ],
//                   ),
//                   trailing: Text('Key: ${product['key']}'),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showClearConfirmDialog(BuildContext context, AdminScreenVm vm) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Xác nhận xóa'),
//           content: const Text(
//             'Bạn có chắc chắn muốn xóa TẤT CẢ sản phẩm trên Supabase?\n\n'
//             'Hành động này không thể hoàn tác!',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Hủy'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 vm.clearSupabaseProducts();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Xóa tất cả'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
