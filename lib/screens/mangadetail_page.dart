import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:convert';

class MangaDetailPage extends StatefulWidget {
  final String id;
  const MangaDetailPage({super.key, required this.id});
  
  @override
  State<MangaDetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  Map<String, dynamic>? book;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchBookDetail();
  }

  Future<void> fetchBookDetail() async {
    try {
      final res = await http.get(
        Uri.parse('http://localhost:3000/api/books/${widget.id}'),
      );

      if (res.statusCode == 200) {
        setState(() {
          book = json.decode(res.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'โหลดข้อมูลไม่สำเร็จ: ${res.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'เกิดข้อผิดพลาด: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error.isNotEmpty) {
      return Scaffold(body: Center(child: Text(error)));
    }

    final fileUrl = 'http://10.0.2.2:3000${book?['filepath'] ?? ''}';

    return Scaffold(
      appBar: AppBar(
        title: Text(book?['title'] ?? 'ไม่มีชื่อ'),
        backgroundColor: Colors.amber,
      ),
      body: SfPdfViewer.network(
        fileUrl,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
