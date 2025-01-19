import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:hencafe/screens/fragments/home_fragment2.dart';

import 'fragments/home_fragment.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _tabIndex = 1;

  int get tabIndex => _tabIndex;

  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Initialize PageController
    pageController = PageController(initialPage: _tabIndex);

    // Initialize AnimationController for FloatingActionBubble
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    // Curved animation
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    // Dispose controllers
    pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showFloatingActionMenu(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15,),
                  Text(
                    "Support",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(color: Colors.grey.shade200),
                  ),
                  ListTile(
                    leading: const Icon(Icons.videocam_outlined),
                    title: const Text("Videos"),
                    onTap: () {
                      Navigator.pop(context);
                      // Handle Settings action
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.message_outlined),
                    title: const Text("Chat"),
                    onTap: () {
                      Navigator.pop(context);
                      // Handle Profile action
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.call),
                    title: const Text("Call"),
                    onTap: () {
                      Navigator.pop(context);
                      pageController.jumpToPage(0); // Navigate to Home page
                    },
                  ),
                ],
              ),
              Positioned(
                right: 0.0,
                child: IconButton(icon: Icon(Icons.close), onPressed: () { Navigator.pop(context); }, ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('User Name'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: HomeFragment2(),
      /*bottomNavigationBar: CircleNavBar(
        activeIndex: tabIndex,
        activeIcons: const [
          Icon(Icons.home_rounded, color: Colors.orangeAccent,size: 30,),
          Icon(Icons.currency_rupee, color: Colors.orangeAccent,size: 30,),
          Icon(Icons.call, color: Colors.orangeAccent,size: 30,),
        ],
        inactiveIcons: const [
          Column(
            children: [
              Icon(Icons.home, size: 20),
              Text("Home"),
            ],
          ),
          Column(
            children: [
              Icon(Icons.currency_rupee, size: 20),
              Text("Sales"),
            ],
          ),
          Column(
            children: [
              Icon(Icons.call, size: 20),
              Text("Contact"),
            ],
          ),
        ],
        color: Colors.grey.shade200,
        circleColor: Colors.grey.shade200,
        height: 60,
        circleWidth: 60,
        onTap: (v) {
          if (v == 2) {
            _showFloatingActionMenu(context);
          } else {
            tabIndex = v;
            pageController.jumpToPage(tabIndex);
          }
        },
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        elevation: 10,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [
          HomeFragment2(),
          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.green),
          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.blue),
        ],
      ),*/
    );
  }

}
