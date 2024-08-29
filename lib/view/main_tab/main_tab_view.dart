import 'package:flutter/material.dart';
import 'package:xworkout/common/color_extension.dart';
import 'package:xworkout/common_widget/tab_button.dart';
import 'package:xworkout/view/progress/progress_view.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: BottomNavigationBar(
          backgroundColor: TColor.white,
          currentIndex: selectTab,
          onTap: (index) {
            setState(() {
              selectTab = index;
              switch (index) {
                case 0:
                  currentTab = const HomeView();
                  break;
                case 1:
                  currentTab = const ProgressView();
                  break;
                case 2:
                  currentTab = const ProfileView();
                  break;
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24, // Set your desired width
                height: 24, // Set your desired height
                child: Image.asset("assets/img/home_tab.png"),
              ),
              activeIcon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset("assets/img/home_tab_select.png"),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset("assets/img/activity_tab.png"),
              ),
              activeIcon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset("assets/img/activity_tab_select.png"),
              ),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset("assets/img/profile_tab.png"),
              ),
              activeIcon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset("assets/img/profile_tab_select.png"),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
