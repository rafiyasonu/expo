import 'package:flutter/material.dart';
import '../../core/constant/colors.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  String selectedMethod = "Bitcoin (BTC)";
  bool hasTradingAccount = false; // 🔴 toggle this from API later

  final TextEditingController amountController = TextEditingController();

  final List<String> paymentMethods = [
    "Bitcoin (BTC)",
    "USDT (TRC20)",
    "Bank Transfer",
    "UPI",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 20),
          _walletBalance(),
          const SizedBox(height: 20),
          _paymentMethodDropdown(),
          const SizedBox(height: 20),
          _amountField(),
          const SizedBox(height: 30),
          hasTradingAccount ? _confirmButton() : _addAccountButton(),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Deposit",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "See all payment methods",
          style: TextStyle(color: Colors.blue),
        ),
      ],
    );
  }

  // ================= WALLET =================

  Widget _walletBalance() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Wallet balance",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 6),
          Text(
            "0.00 USD",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ================= PAYMENT METHOD =================

  Widget _paymentMethodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Method",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedMethod,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: paymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Row(
                    children: [
                      const Icon(Icons.currency_bitcoin,
                          color: Colors.orange),
                      const SizedBox(width: 10),
                      Text(method),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedMethod = value!);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ================= AMOUNT =================

  Widget _amountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Amount",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter amount",
            suffixText: "USD",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  // ================= CONFIRM =================

  Widget _confirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // 🔗 API integration later
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
        ),
        child: const Text(
          "Confirm Deposit",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ================= ADD ACCOUNT =================

  Widget _addAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AccountScreen(),
            ),
          );
        },
        child: const Text(
          "Add Trading Account",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ================= PLACEHOLDER ACCOUNT SCREEN =================

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: const Center(child: Text("Account creation flow here")),
    );
  }
}
