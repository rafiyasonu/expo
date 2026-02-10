import 'package:expo/features/profile/verification/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/constant/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

   @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileBanner(context),
          _infoCarousel(),
          _myAccountsHeader(),
          _accountTabs(),
          _accountCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ================= UI SECTIONS =================

  Widget _profileBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hello. Fill in your account details to make your first deposit",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text("Learn more"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text("Complete profile" ,style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoCarousel() {
    return SizedBox(
      height: 140,
      child: PageView(
        children: [
          _infoCard(
            title: "New timeframes in terminal",
            subtitle:
                "Use 2m, 45m, or custom timeframes for deeper analysis.",
          ),
          _infoCard(
            title: "Secure your funds",
            subtitle: "Enable push notifications to confirm withdrawals.",
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required String subtitle}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle),
          ],
        ),
      ),
    );
  }

  Widget _myAccountsHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "My accounts",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Open account"),
          )
        ],
      ),
    );
  }

  Widget _accountTabs() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text("Real", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 16),
          Text("Demo", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _accountCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text("Real")),
                Chip(label: Text("MT5")),
                Chip(label: Text("Standard")),
              ],
            ),
            const SizedBox(height: 12),
            const Text("#232835630 Standard",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("0.00 USD",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
