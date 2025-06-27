import 'package:flutter/material.dart';
import 'package:hencafe/models/medicine_mode.dart';

import '../services/services.dart';
import '../utils/appbar_widget.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  List<ApiResponse> faqList = [];
  List<ApiResponse> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMedicineData();
  }

  Future<void> fetchMedicineData() async {
    final response = await AuthServices().getMedicine(context, '');
    setState(() {
      faqList = response.apiResponse ?? [];
      filteredList = faqList;
    });
  }

  void filterSearch(String query) {
    final results = faqList.where((faq) {
      final question = faq.subjectLanguage?.toLowerCase() ?? '';
      return question.contains(query.toLowerCase());
    }).toList();
    setState(() => filteredList = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "FAQ's"),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: Builder(
              builder: (_) {
                return filteredList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: filteredList.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return ListTile(
                            title: Text(item.subjectLanguage ?? ''),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FaqDetailPage(data: item),
                                ),
                              );
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FaqDetailPage extends StatelessWidget {
  final ApiResponse data;

  const FaqDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: MyAppBar(title: "Medicine Detail"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Subject',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          Text(
            '     ${data.subjectLanguage}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Details',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          Text(
            '     ${data.detailsLanguage}',
          ),
          const SizedBox(height: 16),
          Text(
            'Usages',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          Text(
            '     ${data.usageLanguage}',
          ),
          const SizedBox(height: 16),
          const Text(
            'References',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          // 👇 GridView inside ListView
          GridView.builder(
            itemCount: data.attachmentInfo!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // prevent GridView from scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  data.attachmentInfo![index].attachmentPath!,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
