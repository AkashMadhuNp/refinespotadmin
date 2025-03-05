import 'package:admin_sec_pro/screens/approved/approvedScreen/model/approved_model.dart';
import 'package:admin_sec_pro/screens/pending/pendingDetailScreen/widget/textfield.dart';
import 'package:admin_sec_pro/screens/widget/imagePreview/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApprovedDetailScreen extends StatefulWidget {
  final SaloonApprovedModel salon;
  const ApprovedDetailScreen({
    super.key, 
    required this.salon
    });

  @override
  State<ApprovedDetailScreen> createState() => _ApprovedDetailScreenState();
}

class _ApprovedDetailScreenState extends State<ApprovedDetailScreen> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BuildFormField(
              label: "Name", 
              value: widget.salon.saloonName
              ),
              BuildFormField(
                  label: 'Phone',
                  value: widget.salon.phone,
                ),
                BuildFormField(
                  label: 'Email',
                  value: widget.salon.email,
                ),
                BuildFormField(
                  label: 'Shop Name',
                  value: widget.salon.saloonName,
                ),
                BuildFormField(
                  label: 'Shop Location',
                  value: widget.salon.location,
                ),

                const SizedBox(height: 16,),
                _buildShopImage(),
                const SizedBox(height: 16,),
                _buildProfileAndLicense()





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


  Widget _buildImageContainer(String imageUrl, double height, String title) {
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

Widget _buildImageSection(String title, String imageUrl) {
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
      _buildImageContainer(imageUrl, 150, title),  
    ],
  );
}
  Widget _buildShopImage() {
    return _buildImageSection('Shop Image', widget.salon.shopUrl);
  }

  Widget _buildProfileAndLicense() {
    return Row(
      children: [
        Expanded(child: _buildImageSection('Profile', widget.salon.profileUrl)),
        const SizedBox(width: 16),
        Expanded(child: _buildImageSection('Shop License', widget.salon.licenseUrl)),
      ],
    );
  }


}