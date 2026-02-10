import 'package:expo/core/constant/colors.dart';
import 'package:flutter/material.dart';

class AddNewAccountScreen extends StatefulWidget {
  const AddNewAccountScreen({super.key});

  @override
  State<AddNewAccountScreen> createState() => _AddNewAccountScreenState();
}

class _AddNewAccountScreenState extends State<AddNewAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();

  String selectedMethod = "PIX";
  String selectedCountry = "Brazil";
  String selectedCurrency = "BRL";
  bool isDefault = false;

  final List<String> paymentMethods = [
    "PIX",
    "BinancePay",
    "Skrill",
    "Neteller",
    "SticPay",
  ];

  final List<String> countries = ["Brazil", "India", "USA"];
  final List<String> currencies = ["BRL", "USD", "INR"];

  @override
  void dispose() {
    _holderNameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      final accountData = {
        "method": selectedMethod,
        "holder": _holderNameController.text,
        "bank": _bankNameController.text,
        "account": _accountNumberController.text,
        "ifsc": _ifscController.text,
        "country": selectedCountry,
        "currency": selectedCurrency,
        "default": isDefault,
      };

      debugPrint(accountData.toString());
      Navigator.pop(context, accountData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Payment Method
              const Text("Payment Method"),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                items: paymentMethods
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => selectedMethod = value!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16),

              /// 🔹 Account Holder Name
              TextFormField(
                controller: _holderNameController,
                decoration: const InputDecoration(
                  labelText: "Account Holder Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter holder name" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 Bank Name
              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(
                  labelText: "Bank Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter bank name" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 Account Number / ID
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  labelText: "Account Number / Wallet ID",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter account number" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 IFSC / Routing Code
              TextFormField(
                controller: _ifscController,
                decoration: const InputDecoration(
                  labelText: "IFSC / Routing Code",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter IFSC / routing code" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 Country
              DropdownButtonFormField<String>(
                value: selectedCountry,
                items: countries
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => selectedCountry = value!),
                decoration: const InputDecoration(
                  labelText: "Country",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Currency
              DropdownButtonFormField<String>(
                value: selectedCurrency,
                items: currencies
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => selectedCurrency = value!),
                decoration: const InputDecoration(
                  labelText: "Currency",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Default Account
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Set as default account"),
                value: isDefault,
                onChanged: (value) => setState(() => isDefault = value),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // 👈 your bg color
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _saveAccount,
                  child: const Text("Save Account"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
