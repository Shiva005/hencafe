import 'package:flutter/material.dart';
import 'package:hencafe/models/medicine_mode.dart';

import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  List<ApiResponse> faqList = [];
  List<ApiResponse> filteredList = [];
  bool isLoading = true;
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
      isLoading = false;
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
      body: RefreshIndicator(
        onRefresh: () => fetchMedicineData(),
        child: Column(
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
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (filteredList.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FaqDetailPage(data: item),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin:
                              EdgeInsets.only(bottom: 8, left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: Text(item.subjectLanguage ?? '')),
                              Icon(
                                Icons.arrow_right_alt_outlined,
                                color: AppColors.primaryColor,
                              )
                            ],
                          ),
                        ),
                      );
                    },
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

class FaqDetailPage extends StatelessWidget {
  final ApiResponse data;

  const FaqDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: MyAppBar(title: "Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              icon: Icons.message_outlined,
              title: "Subject",
              contentText: data.subjectLanguage ?? 'No Details',
            ),

            const SizedBox(height: 10),

            // 🔶 Details Section
            _buildCard(
              icon: Icons.description_outlined,
              title: "Details",
              contentText: data.detailsLanguage ?? 'No Details',
            ),

            const SizedBox(height: 10),

            // ⚠️ Usage & Precautions Section
            _buildCard(
              icon: Icons.info_outline,
              title: "More Info",
              contentText: data.usageLanguage ?? 'No Usage Info',
            ),

            const SizedBox(height: 10),

            // 📎 Attachments
            if (data.attachmentInfo != null &&
                data.attachmentInfo!.isNotEmpty) ...[
              const Text(
                "References",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                itemCount: data.attachmentInfo!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
            ]
          ],
        ),
      ),
    );
  }
}

Widget _buildCard({
  required IconData icon,
  required String title,
  String? subtitle,
  List<String>? contentList,
  String? contentText,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.indigo),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(fontSize: 14)),
        ],
        const SizedBox(height: 12),
        if (contentList != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentList
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          const Text("• ",
                              style: TextStyle(fontSize: 14, height: 1.3)),
                          Expanded(
                            child: Text(e,
                                style:
                                    const TextStyle(fontSize: 14, height: 1.3)),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        if (contentText != null)
          Text(contentText, style: const TextStyle(fontSize: 14, height: 1.5)),
      ],
    ),
  );
}
