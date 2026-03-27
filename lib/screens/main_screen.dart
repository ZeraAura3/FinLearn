import 'package:flutter/material.dart';
import 'package:finlearn/l10n/app_localizations.dart';
import 'tabs/home_tab.dart';
import 'tabs/courses_tab.dart';
import 'tabs/projects_tab.dart';
import 'tabs/learning_tab.dart';
import 'tabs/profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const CoursesTab(),
    const ProjectsTab(),
    const LearningTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: AppLocalizations.of(context)!.translate('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book_outlined),
            activeIcon: const Icon(Icons.book_rounded),
            label: AppLocalizations.of(context)!.translate('nav_courses'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment_rounded),
            label: AppLocalizations.of(context)!.translate('nav_projects'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school_outlined),
            activeIcon: const Icon(Icons.school_rounded),
            label: AppLocalizations.of(context)!.translate('nav_learning'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person_rounded),
            label: AppLocalizations.of(context)!.translate('nav_profile'),
          ),
        ],
      ),
    );
  }
}
