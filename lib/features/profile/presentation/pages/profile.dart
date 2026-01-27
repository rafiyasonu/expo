import 'package:flutter/material.dart';

import '../../../../core/constant/colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exness"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileBanner(),
            _infoCarousel(),
            _myAccountsHeader(),
            _accountTabs(),
            _accountCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _profileBanner() {
    return Container(
      margin: const EdgeInsetsGeometry.fromSTEB(16, 0, 16, 15),
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
                  foregroundColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(horizontal: 20), // 👈 horizontal padding
                ),
                child: const Text("Learn more"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20), // 👈 horizontal padding
                ),
                child: const Text("Complete profile"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoCarousel() {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Text(
            "Real",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
            const Text(
              "#232835630 Standard",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "0.00 USD",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _actionButton(Icons.show_chart, "Trade"),
                _actionButton(Icons.download, "Deposit"),
                _actionButton(Icons.upload, "Withdraw"),
                _actionButton(Icons.more_vert, "More"),
              ],
            ),
            const Divider(height: 32),
            _accountDetail("Actual leverage", "1:200"),
            _accountDetail("Floating P/L", "0.00 USD"),
            _accountDetail("Free margin", "0.00 USD"),
            _accountDetail("Equity", "0.00 USD"),
            _accountDetail("Platform", "MT5"),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }

  Widget _accountDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}