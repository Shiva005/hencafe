import 'package:flutter/material.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDashboardCard(Icons.egg, "Egg Price")),
              SizedBox(width: 20),
              Expanded(
                  child: _buildDashboardCard(Icons.child_care, "Chick Price")),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDashboardCard(
                    Icons.local_fire_department, "Chicken Price"),
              ),
              SizedBox(width: 20),
              Expanded(
                  child:
                      _buildDashboardCard(Icons.restaurant_menu, "Feed Price")),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildDashboardCard(Icons.attach_money, "Sales")),
              SizedBox(width: 20),
              Expanded(child: _buildDashboardCard(Icons.phone, "Contact")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade100, width: 2),
        // Orange border
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        margin: EdgeInsets.zero,
        // Removes extra margin from the card
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.orange),
                const SizedBox(height: 8),
                Text(label, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
