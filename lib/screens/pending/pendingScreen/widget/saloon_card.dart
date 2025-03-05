import 'package:admin_sec_pro/screens/pending/pendingDetailScreen/pending_detail.dart';
import 'package:admin_sec_pro/screens/pending/pendingScreen/model/pending_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalonCard extends StatelessWidget {
  final SaloonPendingModel salon;

  const SalonCard({
    super.key,
    required this.salon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PendingDetailScreen(salon: salon),));
        },
        child: SizedBox(
          height: 200,
          width: 200,
          child: Stack(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue.shade100,
                  image: DecorationImage(
                    image: salon.shopUrl.startsWith('asset/')
                        ? AssetImage(salon.shopUrl) as ImageProvider
                        : NetworkImage(salon.shopUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black26,
                  ),
                  child: Column(
                    children: [
                      Text(
                        salon.saloonName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
        
                      Text(
                    salon.phone,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}