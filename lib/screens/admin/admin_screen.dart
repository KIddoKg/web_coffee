import 'package:flutter/material.dart';
import 'widgets/add_blog_widget.dart';
import 'widgets/blog_management_widget.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<_BlogManagementWidgetState> _blogManagementKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBlogAdded() {
    // Switch to management tab and refresh
    _tabController.animateTo(1);
    // The BlogManagementWidget will auto-refresh when switching tabs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.add),
              text: 'Add Blog',
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'Manage Blogs',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: AddBlogWidget(
              onBlogAdded: _onBlogAdded,
            ),
          ),
          const SingleChildScrollView(
            child: BlogManagementWidget(),
          ),
        ],
      ),
    );
  }
}