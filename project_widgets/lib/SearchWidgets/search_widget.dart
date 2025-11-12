import 'package:flutter/material.dart';

class SearchHeader extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String hintText;

  const SearchHeader({
    super.key,
    required this.onSearch,
    this.hintText = 'ابحث هنا...',
  });

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final searchText = _controller.text.trim();
    if (searchText.isNotEmpty) {
      widget.onSearch(searchText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(158, 158, 158, 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // زر البحث على اليسار (للاتجاه العربي)
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 24),
                onPressed: _handleSearch,
              ),
            ),
            const SizedBox(width: 4),
            // حقل النص على اليمين (للاتجاه العربي)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100, width: 1.5),
                ),
                child: TextField(
                  controller: _controller,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                      color: Colors.grey,
                    ),
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                    color: Colors.blueGrey,
                  ),
                  onSubmitted: (value) => _handleSearch(),
                ),
              ),
            ),

            // النص "بحث" على أقصى اليمين
          ],
        ),
      ),
    );
  }
}
