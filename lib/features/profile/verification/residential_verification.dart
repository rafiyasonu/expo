import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ResidentialVerification extends StatefulWidget {
  const ResidentialVerification({Key? key}) : super(key: key);

  @override
  State<ResidentialVerification> createState() =>
      _ResidentialVerificationState();
}

class _ResidentialVerificationState extends State<ResidentialVerification> {
  final _formKey = GlobalKey<FormState>();

  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final countryCtrl = TextEditingController();

  File? addressProof;
  final picker = ImagePicker();

  Future<void> pickDocument() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        addressProof = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB), // Exness-style background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7FB),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Residential Verification",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Verify your residential address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Upload a valid proof of address issued within the last 3 months",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              _inputField("Full Residential Address", addressCtrl),
              _inputField("City", cityCtrl),
              _inputField("State / Region", stateCtrl),
              _inputField("Postal / PIN Code", pinCtrl,
                  keyboardType: TextInputType.number),
              _inputField("Country", countryCtrl),

              const SizedBox(height: 24),

              const Text(
                "Upload proof of address",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              InkWell(
                onTap: pickDocument,
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: addressProof == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.upload_file,
                                size: 36, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              "Upload utility bill / bank statement",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            addressProof!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1F51), // Exness blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: submitForm,
                  child: const Text(
                    "Submit for verification",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (addressProof == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload proof of address")),
      );
      return;
    }

    // 🔥 Send to backend / KYC API here

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Submitted successfully")),
    );

    Navigator.pop(context);
  }
}
