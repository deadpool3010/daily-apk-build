import 'package:bandhucare_new/feature/search_function/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({super.key, required this.onSearchChanged});
  final ValueChanged<String>? onSearchChanged;
  
  Search get searchController {
    if (!Get.isRegistered<Search>()) {
      Get.put(Search());
    }
    return Get.find<Search>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 44,
        width: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xFFE5EFFE),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.search, color: Color(0xFF3865FF), size: 20),
            Expanded(
              child: TextFormField(
                controller: searchController.searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Color(0xFF3865FF)),
                  hintText: "Search",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets
                      .zero, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
