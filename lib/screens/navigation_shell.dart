import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import 'home_screen.dart';
import 'schedule_screen.dart';
import 'grades_screen.dart';
import 'forms_screen.dart';
import 'clubs_screen.dart';
import 'settings_screen.dart';

class NavigationShell extends StatefulWidget {
  final int initialTab;
  const NavigationShell({super.key, this.initialTab = 0});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  late int _currentIndex;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _screens.addAll([
      const HomeScreen(),
      const ScheduleScreen(),
      const GradesScreen(),
      const FormsScreen(),
      const ClubsScreen(),
      const SettingsScreen(),
    ]);
  }

  void navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE2BFB0), // outline-variant / outline border
              width: 1,
            ),
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(12, 10, 12, bottomPadding > 0 ? bottomPadding : 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Trang chủ'),
            _buildNavItem(1, Icons.calendar_month, 'Lịch học'),
            _buildNavItem(2, Icons.assessment, 'Bảng điểm'),
            _buildNavItem(3, Icons.description, 'Đơn từ'),
            _buildNavItem(4, Icons.groups, 'CLB'),
            _buildNavItem(5, Icons.settings_outlined, 'Cài đặt'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                gradient: const LinearGradient(
                  colors: [Color(0xffFFA726), Color(0xffFF7043)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffFF9800).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppColors.onSurfaceVariant,
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: AppStyles.labelSm.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
// Helper to navigate to tabs from children
class NavigationShellController {
  static void navigateTo(BuildContext context, int tabIndex) {
    final state = context.findAncestorStateOfType<_NavigationShellState>();
    if (state != null) {
      state.navigateToTab(tabIndex);
    }
  }
}
