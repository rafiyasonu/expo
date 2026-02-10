import 'package:expo/features/accounts/new_account_screen.dart';
import 'package:flutter/material.dart';

class AddAccountsScreen extends StatefulWidget {
  const AddAccountsScreen({super.key});

  @override
  State<AddAccountsScreen> createState() => _AddAccountsScreenState();
}

class _AddAccountsScreenState extends State<AddAccountsScreen> {
  // 🔹 Static account data
  final List<Map<String, String>> accounts = [
    {"bank": "PIX", "account": "**** 2345"},
    {"bank": "BinancePay", "account": "User@binance"},
  ];

  void _openAddAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddNewAccountScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddAccount,
          )
        ],
      ),
      body: accounts.isEmpty
          ? const Center(child: Text("No accounts added yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: Text(account["bank"]!),
                    subtitle: Text(account["account"]!),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddAccount,
        child: const Icon(Icons.add),
      ),
    );
  }
}
