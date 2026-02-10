import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:expo/features/accounts/accounts_screen.dart';
import 'package:expo/features/accounts/deposit_screen.dart';
import 'package:expo/features/accounts/withdrawal.dart';
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

  /// Wallet Data
  bool hideBalance = false;
  double walletBalance = 0.00;
  String walletId = "1218392945974120434";

  /// Pages
  final List<Widget> _pages = const [
    DashboardScreen(),
    Center(child: Text("Trade")),
    DepositScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      /// DRAWER
      drawer: _drawer(),

      /// APPBAR
      appBar: AppBar(
        title: const Text("Exness"),

      /// PROFILE ICON WITH BG COLOR
leading: Padding(
  padding: const EdgeInsets.all(8),
  child: InkWell(
    borderRadius: BorderRadius.circular(50),
    onTap: () => _scaffoldKey.currentState?.openDrawer(),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary, // 🎨 BG COLOR
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: _profileIcon(size: 22), // reduce icon size
    ),
  ),
),


        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),

      /// BODY
      body: Column(
        children: [
          Expanded(child: _pages[_currentIndex]),
        ],
      ),

      /// BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
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

  // ================= PROFILE ICON =================

  Widget _profileIcon({double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }

  // ================= DRAWER =================

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          /// FIXED DRAWER HEADER (NO OVERFLOW)
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// PROFILE ICON + AMOUNT (ONE ROW)
                Row(
                  children: [
                    _profileIcon(size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hideBalance
                            ? "**** USD"
                            : "${walletBalance.toStringAsFixed(2)} USD",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// ACCOUNT ID
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Account ID: $walletId",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.copy,
                        size: 16,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: walletId),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account ID copied"),
                          ),
                        );
                      },
                    ),
                  ],
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
            icon: Icons.account_balance,
            title: "Add Account",
            onTap: () => _navigate(AddAccountsScreen()),
          ),

          _drawerItem(
            icon: Icons.account_balance_wallet,
            title: "Withdrawal",
            onTap: () => _navigate(WithdrawalScreen()),
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
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
