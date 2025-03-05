import 'package:admin_sec_pro/screens/pending/pendingDetailScreen/widget/textfield.dart';
import 'package:admin_sec_pro/screens/rejected/rejectedScreen/model/rejected_model.dart';
import 'package:admin_sec_pro/screens/widget/imagePreview/image_preview.dart';  // Add this import
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RejectedDetailScreen extends StatelessWidget {
  final SaloonRejectedModel salon;
  const RejectedDetailScreen({super.key, required this.salon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BuildFormField(
              label: "name", 
              value: salon.name),
            BuildFormField(
              label: 'Phone',
              value: salon.phone,
            ),
            BuildFormField(
              label: 'Email',
              value: salon.email,
            ),
            BuildFormField(
              label: 'Shop Name',
              value: salon.saloonName,
            ),
            BuildFormField(
              label: 'Shop Location',
              value: salon.location,
            ),
            const SizedBox(height: 16),
            _buildShopImage(context),
            const SizedBox(height: 16),
            _buildProfileAndLicense(context)
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'REFINE SPOT',
        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue.shade300,
      foregroundColor: Colors.white,
    );
  }

  Widget _buildImageContainer(BuildContext context, String imageUrl, double height, String title) {
    return GestureDetector(
      onTap: () => ImagePreview.show(context, title, imageUrl),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Icon(
              Icons.zoom_in,
              color: Colors.white,
              size: 36,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, String title, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        _buildImageContainer(context, imageUrl, 150, title),
      ],
    );
  }

  Widget _buildShopImage(BuildContext context) {
    return _buildImageSection(context, 'Shop Image', salon.shopUrl);
  }

  Widget _buildProfileAndLicense(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildImageSection(context, 'Profile', salon.profileUrl)),
        const SizedBox(width: 16),
        Expanded(child: _buildImageSection(context, 'Shop License', salon.licenseUrl)),
      ],
    );
  }
}