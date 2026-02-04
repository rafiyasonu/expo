import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expo/core/constant/colors.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  final Map<String, Map<String, dynamic>> verificationData = {
    "Aadhaar Card": {
      "status": "pending",
      "uploadedSides": 0,
      "totalSides": 2,
      "documents": [
        {
          "name": "Front Side",
          "fileName": "",
          "size": "0 KB",
          "status": "pending",
          "file": null,
        },
        {
          "name": "Back Side",
          "fileName": "",
          "size": "0 KB",
          "status": "pending",
          "file": null,
        }
      ]
    },
    "PAN Card": {
      "status": "pending",
      "uploadedSides": 0,
      "totalSides": 2,
      "documents": [
        {
          "name": "Front Side",
          "fileName": "",
          "size": "0 KB",
          "status": "pending",
          "file": null,
        },
        {
          "name": "Back Side",
          "fileName": "",
          "size": "0 KB",
          "status": "pending",
          "file": null,
        }
      ]
    },
    "Bank Passbook": {
      "status": "pending",
      "uploadedSides": 0,
      "totalSides": 2,
      "documents": [
        {
          "name": "Front Page",
          "fileName": "",
          "size": "0 KB",
          "status": "pending",
          "file": null,
        },
        {
          "name": "Last Bank Statement",
          "fileName": "",
          "size": "0 KB",
          "status": "pending",
          "file": null,
        }
      ]
    },
  };

  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    int totalDocuments = verificationData.length;
    int uploadedDocuments = verificationData.values
        .where((doc) => doc["uploadedSides"]! > 0)
        .length;
    int approvedDocuments = verificationData.values
        .where((doc) => doc["status"] == "approved")
        .length;
    int fullyUploadedDocuments = verificationData.values
        .where((doc) => doc["uploadedSides"] == doc["totalSides"])
        .length;

    bool allDocumentsUploaded = fullyUploadedDocuments == totalDocuments;
    bool allDocumentsApproved = approvedDocuments == totalDocuments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Verification"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with stats
            _buildHeaderSection(totalDocuments, fullyUploadedDocuments, approvedDocuments),
            
            const SizedBox(height: 24),
            
            // How it works section
            _buildHowItWorksSection(),
            
            const SizedBox(height: 32),
            
            // Required Documents Section
            const Text(
              "Required Documents",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              "Upload these 3 documents for verification",
              style: TextStyle(color: Colors.grey),
            ),
            
            const SizedBox(height: 16),
            
            // Document List
            ...verificationData.entries.map((entry) {
              return _buildDocumentCard(entry.key, entry.value);
            }).toList(),
            
            // All Uploaded Message
            if (allDocumentsUploaded && !allDocumentsApproved)
              _buildAllUploadedMessage(),
            
            // Submit Button
            if (allDocumentsUploaded && !allDocumentsApproved)
              _buildSubmitButton(),
            
            const SizedBox(height: 20),
            
            // Verification Guidelines
            _buildVerificationGuidelines(),
            
            const SizedBox(height: 40), // Extra space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildAllUploadedMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All documents uploaded!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You can now submit all documents for verification.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: [
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitAllDocuments,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: AppColors.primary.withOpacity(0.3),
              ),
              child: _isSubmitting
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Submitting...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user, size: 24),
                        SizedBox(width: 12),
                        Text(
                          "SUBMIT FOR VERIFICATION",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Submission Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Verification usually takes 24-48 hours. You'll be notified once completed.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _uploadDocumentSide(String documentType, int sideIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        "Upload ${_getSideName(sideIndex)}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "For $documentType",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                
                // Scrollable content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 20),
                      
                      // Upload options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildUploadOption(
                            icon: Icons.camera_alt,
                            label: "Camera",
                            onTap: () async {
                              Navigator.pop(context);
                              final image = await _picker.pickImage(source: ImageSource.camera);
                              if (image != null) {
                                _handleUploadedImage(image, documentType, sideIndex);
                              }
                            },
                          ),
                          _buildUploadOption(
                            icon: Icons.photo_library,
                            label: "Gallery",
                            onTap: () async {
                              Navigator.pop(context);
                              final image = await _picker.pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                _handleUploadedImage(image, documentType, sideIndex);
                              }
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Upload Guidelines
                      _buildUploadGuidelines(documentType, sideIndex),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                
                // Cancel button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Icon(icon, color: AppColors.primary, size: 36),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  void _handleUploadedImage(XFile image, String documentType, int sideIndex) async {
    final file = File(image.path);
    final fileSize = await file.length();
    final sizeText = _formatFileSize(fileSize);
    
    setState(() {
      final docData = verificationData[documentType]!;
      final side = docData["documents"][sideIndex] as Map<String, dynamic>;
      
      side["file"] = file;
      side["fileName"] = image.name;
      side["size"] = sizeText;
      side["status"] = "uploaded";
      
      // Update uploaded sides count
      int uploadedCount = 0;
      for (var doc in docData["documents"]) {
        if (doc["status"] == "uploaded" || doc["status"] == "approved") {
          uploadedCount++;
        }
      }
      docData["uploadedSides"] = uploadedCount;
      
      // Update overall status if all sides uploaded
      if (uploadedCount == docData["totalSides"]) {
        docData["status"] = "uploaded";
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${_getSideName(sideIndex)} side uploaded successfully"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildUploadGuidelines(String documentType, int sideIndex) {
    String guidelines = "";
    
    if (documentType == "Aadhaar Card") {
      guidelines = sideIndex == 0 
        ? "• Ensure front side is clearly visible\n• Show full Aadhaar card\n• Details should be readable"
        : "• Ensure back side is clearly visible\n• QR code should be visible\n• No glare or reflections";
    } else if (documentType == "PAN Card") {
      guidelines = sideIndex == 0 
        ? "• Front side with PAN number\n• Full name should be visible\n• Father's name and DOB clear"
        : "• Signature side\n• Date of issue visible\n• No cuts or damages";
    } else if (documentType == "Bank Passbook") {
      guidelines = sideIndex == 0 
        ? "• First page with account details\n• Account holder name visible\n• Account number clear"
        : "• Last transaction page\n• Bank name and branch visible\n• Recent transactions shown";
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "Upload Guidelines",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            guidelines,
            style: const TextStyle(fontSize: 12, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(String documentName, Map<String, dynamic> data) {
    final icon = _getDocumentIcon(documentName);
    final description = _getDocumentDescription(documentName);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Document header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              documentName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            _buildStatusBadge(data["status"]),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: data["uploadedSides"] / data["totalSides"],
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        data["uploadedSides"] == data["totalSides"] 
                          ? Colors.green 
                          : AppColors.primary
                      ),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "${data["uploadedSides"]}/${data["totalSides"]}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: data["uploadedSides"] == data["totalSides"] 
                        ? Colors.green 
                        : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Document sides
              Column(
                children: (data["documents"] as List).asMap().entries.map((entry) {
                  final index = entry.key;
                  final doc = entry.value as Map<String, dynamic>;
                  return _buildDocumentSideItem(doc, index, documentName);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentSideItem(Map<String, dynamic> doc, int index, String documentType) {
    final isUploaded = doc["status"] == "uploaded" || doc["status"] == "approved";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isUploaded ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _uploadDocumentSide(documentType, index),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Status Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isUploaded ? Colors.green.shade100 : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isUploaded ? Icons.check : Icons.cloud_upload,
                    color: isUploaded ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isUploaded ? Colors.green.shade800 : Colors.black,
                        ),
                      ),
                      if (isUploaded && doc["fileName"].isNotEmpty)
                        Text(
                          doc["fileName"],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                
                // File size and status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      doc["size"],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                      ),
                    ),
                    if (isUploaded)
                      Text(
                        "Uploaded",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      Text(
                        "Tap to upload",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(int totalDocs, int uploadedDocs, int approvedDocs) {
    final allUploaded = uploadedDocs == totalDocs;
    final allApproved = approvedDocs == totalDocs;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: allApproved ? Colors.green.shade50 : 
               allUploaded ? Colors.blue.shade50 : 
               AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allApproved ? Colors.green.shade200 : 
                 allUploaded ? Colors.blue.shade200 : 
                 AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Account Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (allApproved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Verified",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            "$uploadedDocs of $totalDocs documents fully uploaded",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          
          Text(
            "$approvedDocs of $totalDocs documents approved",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Progress indicator with labels
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upload Progress",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${(uploadedDocs / totalDocs * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: uploadedDocs / totalDocs,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  allUploaded ? Colors.green : AppColors.primary
                ),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          
          if (allUploaded && !allApproved)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "All documents uploaded! Submit for verification below.",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _submitAllDocuments() async {
    // Check if all documents are fully uploaded
    bool canSubmit = verificationData.values
        .every((doc) => doc["uploadedSides"] == doc["totalSides"]);
    
    if (!canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload all required sides before submitting"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    // Show submitting status
    setState(() {
      for (var doc in verificationData.values) {
        doc["status"] = "submitted";
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Documents submitted for verification"),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );
    
    // Simulate verification process with delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      verificationData["Aadhaar Card"]!["status"] = "approved";
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      verificationData["PAN Card"]!["status"] = "approved";
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      verificationData["Bank Passbook"]!["status"] = "approved";
      _isSubmitting = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All documents have been approved! Your account is now verified."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "How to verify your account:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildStepItem(1, "Upload both sides of each document"),
          _buildStepItem(2, "Ensure photos are clear and readable"),
          _buildStepItem(3, "Submit all documents for verification"),
          _buildStepItem(4, "Get verified within 24 hours"),
        ],
      ),
    );
  }

  Widget _buildVerificationGuidelines() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.security, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                "Verification Guidelines",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          _buildGuidelineItem("Aadhaar Card", "• Both front and back sides required\n• Details must be clearly visible\n• Should not be expired"),
          _buildGuidelineItem("PAN Card", "• Front with PAN number\n• Back with signature\n• Should match your name"),
          _buildGuidelineItem("Bank Passbook", "• First page with account details\n• Last transaction page\n• Bank name and IFSC visible"),
          
          const SizedBox(height: 12),
          
          const Text(
            "Note: Your documents are securely encrypted and will be verified within 24-48 hours.",
            style: TextStyle(fontSize: 12, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem(String title, String guidelines) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            guidelines,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "$step",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    IconData icon;
    
    switch (status) {
      case "approved":
        color = Colors.green;
        text = "Approved";
        icon = Icons.verified;
        break;
      case "uploaded":
        color = Colors.blue;
        text = "Uploaded";
        icon = Icons.cloud_done;
        break;
      case "submitted":
        color = Colors.orange;
        text = "In Review";
        icon = Icons.hourglass_empty;
        break;
      case "pending":
      default:
        color = Colors.grey;
        text = "Pending";
        icon = Icons.pending;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(2)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  IconData _getDocumentIcon(String documentType) {
    switch (documentType) {
      case "Aadhaar Card":
        return Icons.credit_card;
      case "PAN Card":
        return Icons.badge;
      case "Bank Passbook":
        return Icons.account_balance;
      default:
        return Icons.description;
    }
  }

  String _getDocumentDescription(String documentType) {
    switch (documentType) {
      case "Aadhaar Card":
        return "Government issued identity proof";
      case "PAN Card":
        return "Permanent Account Number card";
      case "Bank Passbook":
        return "Bank account proof with transactions";
      default:
        return "Required document";
    }
  }

  String _getSideName(int index) {
    switch (index) {
      case 0: return "Front";
      case 1: return "Back";
      case 2: return "Side 3";
      case 3: return "Side 4";
      default: return "Side ${index + 1}";
    }
  }
}