import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagePreview extends StatelessWidget {
  final String imageUrl;
  final String title;
  
  const ImagePreview({
    super.key, 
    required this.imageUrl, 
    required this.title
    });

    static void show(BuildContext context,String title,String imageUrl){
      showDialog(
        context: context, 
        builder:(BuildContext context) {
          return ImagePreview(
            imageUrl: imageUrl, 
            title: title
            );
        },);
    }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),


                  IconButton(
                    onPressed:()=>Navigator.of(context).pop() ,
                     icon:const Icon(Icons.close))
                ],
              ),
               ),


               Flexible(
                child:InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded/
                          loadingProgress.expectedTotalBytes!
                          : null,
                        ),
                      );
                    },

                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                          )
                        ,

                      );
                    },
                    
                    )
                    ) 
               )

          ],
        ),
      ),

    );
  }
}