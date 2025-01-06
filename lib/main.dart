// Main Flutter code file (lib/main.dart)
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookSearchScreen(),
    );
  }
}

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchType = 'author';
  List<dynamic> _books = [];

  Future<void> _searchBooks() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    final url = Uri.parse("http://192.168.15.61/books/books.php");
    final response = await http.post(url, body: {
      'query': query,
      'type': _searchType,
    });

    if (response.statusCode == 200) {
      setState(() {
        _books = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch books.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Finder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Author'),
                    leading: Radio(
                      value: 'author',
                      groupValue: _searchType,
                      onChanged: (value) {
                        setState(() {
                          _searchType = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Subject'),
                    leading: Radio(
                      value: 'subject',
                      groupValue: _searchType,
                      onChanged: (value) {
                        setState(() {
                          _searchType = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchBooks,
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return ListTile(
                    title: Text(book['title']),
                    subtitle: Text('Author: ${book['author']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
