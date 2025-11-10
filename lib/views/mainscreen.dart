import 'package:diosample/views/addproductspage.dart';
import 'package:diosample/views/productspage.dart';
import 'package:flutter/material.dart';
import 'package:diosample/views/homepage.dart';
import 'package:diosample/service/usersevice.dart';
import 'package:diosample/views/loginpage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final UserService _userService = UserService();

  // Callbacks to trigger refresh
  VoidCallback? _homepageRefresh;
  VoidCallback? _myProductsRefresh;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _userService.clearUser();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _refreshCurrentPage() {
    // Call the appropriate refresh callback
    if (_currentIndex == 0 && _homepageRefresh != null) {
      _homepageRefresh!();
    } else if (_currentIndex == 1 && _myProductsRefresh != null) {
      _myProductsRefresh!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );

          // Refresh the current page if product was added
          if (result == true) {
            _refreshCurrentPage();
          }
        },
      ),
      appBar: AppBar(
        title: Text(_getTitleForIndex(_currentIndex)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Homepage(
            onRefreshCallbackSet: (callback) {
              _homepageRefresh = callback;
            },
          ),
          MyProductsPage(
            onRefreshCallbackSet: (callback) {
              _myProductsRefresh = callback;
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'All Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'My Products',
          ),
        ],
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'All Products';
      case 1:
        return 'My Products';
      default:
        return 'Products';
    }
  }
}
