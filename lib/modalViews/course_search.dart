import 'package:flutter/material.dart';

class SearchModal extends StatefulWidget {
  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _results = [];

  void _onSearchChanged(String query) {
    // Simulate search results based on the query
    setState(() {
      _results = List.generate(10, (index) => '$query Result $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_results[index]),
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