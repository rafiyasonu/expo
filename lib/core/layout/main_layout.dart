import 'package:expo/features/accounts/deposit_screen.dart';
import 'package:flutter/material.dart';
import 'package:expo/features/dashboard/dashboard.dart';
import 'package:expo/features/profile/verification/profile_screen.dart';
import 'package:expo/features/profile/verification/verification_screen.dart';
import 'package:expo/features/settings/settings_screen.dart';

import '../constant/colors.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  // 🔹 GLOBAL PAGES
  final List<Widget> _pages = const [
    DashboardScreen(),   // Home
    Center(child: Text("Trade")), // Trade (future)
    DepositScreen(),     // ✅ Deposit integrated
    ProfileScreen(),     // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // 🔹 GLOBAL DRAWER
      drawer: _globalDrawer(),

      // 🔹 GLOBAL APP BAR
      appBar: AppBar(
        title: const Text("Exness"),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white),
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),

      // 🔹 PAGE CONTENT
      body: _pages[_currentIndex],

      // 🔹 GLOBAL BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Trade",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Deposit",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // ================= DRAWER =================

  Widget _globalDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30),
                ),
                SizedBox(height: 12),
                Text(
                  "User Menu",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "user@email.com",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          _drawerItem(
            icon: Icons.person,
            title: "Profile",
            onTap: () => _navigate(const ProfileScreen()),
          ),

          _drawerItem(
            icon: Icons.verified,
            title: "Verification",
            onTap: () => _navigate(const VerificationScreen()),
          ),

          _drawerItem(
            icon: Icons.settings,
            title: "Settings",
            onTap: () => _navigate(const SettingsScreen()),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigate(Widget page) {
    Navigator.pop(context); // close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
