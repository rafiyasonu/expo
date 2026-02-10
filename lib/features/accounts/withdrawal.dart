import 'package:expo/core/constant/colors.dart';
import 'package:flutter/material.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  // 🔹 Static wallet balance
  double walletBalance = 2743.00;

  // 🔹 Static payment methods
  final List<Map<String, dynamic>> paymentMethods = [
    {
      "name": "PIX payment",
      "currency": "BRL",
      "min": 10.0,
      "max": 9500.0,
      "fee": 0.0,
      "time": "1 hour - 24 hours",
    },
    {
      "name": "BinancePay",
      "currency": "USD",
      "min": 10.0,
      "max": 20000.0,
      "fee": 0.0,
      "time": "Instant - 30 minutes",
    },
    {
      "name": "Skrill",
      "currency": "USD",
      "min": 10.0,
      "max": 12000.0,
      "fee": 0.0,
      "time": "Instant - 24 hours",
    },
  ];

  late Map<String, dynamic> selectedMethod;
  double withdrawAmount = 0.0;

  @override
  void initState() {
    super.initState();
    selectedMethod = paymentMethods.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    setState(() {
      withdrawAmount = double.tryParse(value) ?? 0.0;
    });
  }

  void _submitWithdrawal() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Withdrawal of \$${withdrawAmount.toStringAsFixed(2)} via ${selectedMethod['name']} submitted",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Withdrawal")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Payment Method
              const Text(
                "Payment method",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              DropdownButtonFormField<Map<String, dynamic>>(
                value: selectedMethod,
                items: paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method["name"]),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value!;
                    withdrawAmount = 0;
                    _amountController.clear();
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16),

              /// 🔹 Wallet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "From account",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "\$${walletBalance.toStringAsFixed(2)} USD",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// 🔹 Amount
              const Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                onChanged: _onAmountChanged,
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  suffixText: selectedMethod["currency"],
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final amount = double.tryParse(value ?? "");
                  if (amount == null) return "Enter valid amount";
                  if (amount < selectedMethod["min"]) {
                    return "Minimum ${selectedMethod["min"]}";
                  }
                  if (amount > selectedMethod["max"]) {
                    return "Maximum ${selectedMethod["max"]}";
                  }
                  if (amount > walletBalance) {
                    return "Insufficient balance";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 6),

              Text(
                "${selectedMethod["min"]} - ${selectedMethod["max"]} USD",
                style: const TextStyle(color: Colors.blue),
              ),

              const SizedBox(height: 20),

              /// 🔹 To be withdrawn
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "To be withdrawn",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${withdrawAmount.toStringAsFixed(2)} ${selectedMethod["currency"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      // Always use primary color
                      return AppColors.primary;
                    }),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: withdrawAmount > 0 ? _submitWithdrawal : null,
                  child: const Text("Continue"),
                ),
              ),

              /// 🔹 Terms
              const Text(
                "Terms",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text("Average payment time: ${selectedMethod["time"]}"),
              Text("Fee: ${selectedMethod["fee"]}%"),
            ],
          ),
        ),
      ),
    );
  }
}
