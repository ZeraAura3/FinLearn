import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for debug checks
import 'pdf_viewer_screen.dart';

class CategoryPDFListScreen extends StatelessWidget {
  final String categoryName;
  final bool isEmbedded;

  const CategoryPDFListScreen({
    super.key,
    required this.categoryName,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    // DEBUG: Check Auth status before query
    final user = FirebaseAuth.instance.currentUser;
    print("Listing PDFs for collection: '$categoryName'");
    print("Current User: ${user?.uid ?? 'Not Signed In'}");
    
    Widget content = StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(categoryName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading PDFs',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}'.contains('PERMISSION_DENIED')
                        ? 'Permission Denied: Check Firestore Rules for collection "$categoryName"'
                        : 'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No PDFs found for this category.'),
                const SizedBox(height: 8),
                Text(
                  'Checked Collection: "$categoryName"',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            // Debugging: Print to confirm we found it
            // print('Doc ID: ${docs[index].id} - Keys: ${data.keys.toList()}');

            // Smart Key Search: Find 'title' or 'name' ignoring case & spaces
            String title = 'Untitled PDF';
            String? matchingKey;

            for (var key in data.keys) {
              String cleanedKey = key.trim().toLowerCase();
              if (cleanedKey == 'title' || cleanedKey == 'name') {
                matchingKey = key;
                break;
              }
            }

            if (matchingKey != null && data[matchingKey] is String) {
              title = data[matchingKey] as String;
            }

            // Safe access for pdfURL
            String? pdfUrl;
            if (data['pdfURL'] is String) {
              pdfUrl = data['pdfURL'] as String;

              // --- URL CLEANING LOGIC ---
              pdfUrl = pdfUrl.trim(); // 1. Trim whitespace

              // 2. Remove leading slash if present (common copy-paste error)
              if (pdfUrl.startsWith('/')) {
                pdfUrl = pdfUrl.substring(1);
              }

              // 3. Fix malformed protocol (single slash)
              if (pdfUrl.startsWith('https:/') &&
                  !pdfUrl.startsWith('https://')) {
                pdfUrl = pdfUrl.replaceFirst('https:/', 'https://');
              }
              if (pdfUrl.startsWith('http:/') &&
                  !pdfUrl.startsWith('http://')) {
                pdfUrl = pdfUrl.replaceFirst('http:/', 'http://');
              }

              // 4. Fix Bucket Name typo (Coursepdfs -> Course-pdfs)
              if (pdfUrl.contains('/Coursepdfs/')) {
                pdfUrl = pdfUrl.replaceFirst('/Coursepdfs/', '/Course-pdfs/');
              }

              // 5. Debuging: check for encoding issues
              print('Attempting to open PDF: $pdfUrl');
            } else {
              print(
                'Warning: pdfURL is not a string for doc ${docs[index].id}: ${data['pdfURL'].runtimeType}',
              );
            }

            // Fallback: If title is 'Untitled PDF' (default) calculate from Filename
            if ((title == 'Untitled PDF' || title.isEmpty) &&
                pdfUrl != null &&
                pdfUrl.isNotEmpty) {
              try {
                final uri = Uri.parse(pdfUrl);
                // Get the last segment (filename)
                String fileName = uri.pathSegments.last;
                // Decode URL encoding (e.g. %20 -> space)
                fileName = Uri.decodeComponent(fileName);
                // Remove extension
                if (fileName.toLowerCase().endsWith('.pdf')) {
                  fileName = fileName.substring(0, fileName.length - 4);
                }
                title = fileName;
              } catch (e) {
                print('Could not extract title from URL: $e');
              }
            }

            return ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(title),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                if (pdfUrl != null && pdfUrl.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PDFViewerScreen(title: title, pdfUrl: pdfUrl!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid PDF URL')),
                  );
                }
              },
            );
          },
        );
      },
    );

    if (isEmbedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: content,
    );
  }
}
