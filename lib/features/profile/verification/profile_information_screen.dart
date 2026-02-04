import 'package:flutter/material.dart';
import 'package:expo/core/constant/colors.dart';

class ProfileInformationScreen extends StatefulWidget {
  const ProfileInformationScreen({super.key});

  @override
  State<ProfileInformationScreen> createState() =>
      _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add profile information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            _label("First Name"),
            _inputField(),
            _hint("Your first name as shown on your ID"),

            const SizedBox(height: 16),

            _label("Last Name"),
            _inputField(),
            _hint("Your last name as shown on your ID"),

            const SizedBox(height: 16),

            _label("Date of birth"),
            Row(
              children: [
                Expanded(child: _dropdownField("Day")),
                const SizedBox(width: 8),
                Expanded(child: _dropdownField("Month")),
                const SizedBox(width: 8),
                Expanded(child: _dropdownField("Year")),
              ],
            ),

            const SizedBox(height: 16),

            _label("Country of birth"),
            _dropdownField("Select country"),

            const SizedBox(height: 16),

            _label("Your gender"),
            Row(
              children: [
                _radio("Female"),
                _radio("Male"),
                _radio("Other"),
              ],
            ),

            const SizedBox(height: 16),

            _label("Your residential address"),
            _inputField(hint: "City, Street, house (apartment)"),
            _hint("You will be asked to verify your address later"),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    // submit profile info
                  },
                  child: const Text("Submit" ,
                  style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widgets

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      );

  Widget _hint(String text) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );

  Widget _inputField({String? hint}) => TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      );

  Widget _dropdownField(String hint) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hint,
              style: const TextStyle(color: Colors.grey),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      );

  Widget _radio(String value) => Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: gender,
            onChanged: (v) => setState(() => gender = v),
          ),
          Text(value),
        ],
      );
}
