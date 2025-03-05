import 'package:admin_sec_pro/screens/pending/pendingDetailScreen/service/approve_rejection.dart';
import 'package:admin_sec_pro/screens/widget/imagePreview/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_sec_pro/screens/pending/pendingDetailScreen/widget/textfield.dart';
import 'package:admin_sec_pro/screens/pending/pendingScreen/model/pending_model.dart';

class PendingDetailScreen extends StatefulWidget {
  final SaloonPendingModel salon;
  
  const PendingDetailScreen({super.key, required this.salon});

  @override
  State<PendingDetailScreen> createState() => _PendingDetailScreenState();
}

class _PendingDetailScreenState extends State<PendingDetailScreen> {
  final ApproveRejectionService _saloonService = ApproveRejectionService();
  bool _isLoading = false;

  
  Future<void> _handleApprove() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _saloonService.approveSaloon(widget.salon);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Saloon Approved successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to Approve Saloon: $e")),
        );
      }
    } finally {
      if (mounted) setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleReject() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _saloonService.rejectSaloon(widget.salon);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Saloon Rejected successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to Reject Saloon: $e")),
        );
      }
    } finally {
      if (mounted) setState(() {
        _isLoading = false;
      });
    }
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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildFormField(
              label: 'Name',
              value: widget.salon.saloonName,
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
            suffix: IconButton(
              icon: const Icon(Icons.map_outlined),
              onPressed: (){},
            ),
          ),                   
           const SizedBox(height: 16),
            _buildShopImage(),
            const SizedBox(height: 16),
            _buildProfileAndLicense(),
            const SizedBox(height: 24),
            _buildActionButtons(),
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

  Widget _buildActionButton({
    required String text,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(text),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildActionButton(
          text: 'Approve',
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.black,
          onPressed: _handleApprove,
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          text: 'Reject',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          onPressed: _handleReject,
        ),
      ],
    );
  }


//   void _showLocationMap(BuildContext context) {
//   // Assuming your salon model has latitude and longitude fields
//   final location = LatLng(widget.salon.latitude, widget.salon.longitude);
  
//   showDialog(
//     context: context,
//     builder: (context) => LocationMapDialog(
//       location: location,
//       address: widget.salon.location,
//     ),
//   );
// }
}