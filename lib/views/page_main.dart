import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/ui/restaurant_list.dart';
import 'package:restaurant_app/ui/page_favorites.dart';
import 'package:restaurant_app/ui/page_settings.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/views/page_detail.dart';

class PageMain extends StatefulWidget {
  static const routeName = '/restaurant_list';

  const PageMain({super.key});

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  int _bottomNavIndex = 0;
  static const String _mainMenuText = 'Main Menu';

  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<Widget> _listWidget = [
    const RestaurantList(),
    const PageFavorites(),
    const SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.storefront),
      label: _mainMenuText,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: PageFavorites.favoritesTitle,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: SettingsPage.settingsTitle,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(PageDetail.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
