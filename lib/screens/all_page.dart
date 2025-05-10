import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'mangadetail_page.dart';

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  List<dynamic> books = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/books'), // เปลี่ยนตาม IP ของคุณ
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          books = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'โหลดข้อมูลไม่สำเร็จ: ${response.statusCode}';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('มังงะทั้งหมด'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  final coverUrl =
                      book['coverImage'] != null
                          ? 'http://localhost:3000${book['coverImage']}'
                          : null;
              
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    MangaDetailPage(id: book['id'].toString()),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            coverUrl != null
                                ? Image.network(
                                  coverUrl,
                                  width: 60,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image),
                                )
                                : const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                ),
                      ),
                      title: Text(
                        book['title'] ?? 'ไม่มีชื่อ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        book['author'] ?? 'ไม่ทราบผู้แต่ง',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
