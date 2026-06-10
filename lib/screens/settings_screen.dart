import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Đăng xuất',
              style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Bạn có chắc muốn đăng xuất khỏi tài khoản không?',
          style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Huỷ',
              style: AppStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.logout_rounded, size: 16, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            AppStyles.containerPadding,
            MediaQuery.of(context).padding.top + 8,
            AppStyles.containerPadding,
            8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cài đặt',
                style: AppStyles.headlineLg.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.settings_outlined, color: AppColors.primary, size: 20),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppStyles.containerPadding,
          vertical: AppStyles.stackLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile card ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryContainer, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDIoZyg0rzyaYKuoOTnbhYUo4ejXsh4SyOaBRA2ziuWkG2pNHhpks8XXSmRWBgduqrC0H33p4gl5AE-LQkYpkLdIptHkw0ExzEWcnuGN4Mr6Xd3KX-H0DIAQ2cea8CQo0NHk4zrY5wEAaj1X7E3U-77bjdpKrTk2y_Z0E0sy7Jbogg-zLiQzKfhXAyo7PombQ4GX1UN8v5vac2hucwzpFlOnx0rpu-D9tTDNadSONqfBlrvpskgj91KeC13x8se5ke4ZeLauVoFcKrv',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nguyễn Văn A',
                          style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Học sinh · Lớp 11A1',
                          style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'HS2024001',
                            style: AppStyles.labelSm.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.stackLg),

            // ── Tài khoản ─────────────────────────────────────────
            _buildSectionLabel('Tài khoản'),
            const SizedBox(height: AppStyles.stackMd),
            _buildSettingsGroup([
              _buildNavTile(
                icon: Icons.person_outline,
                iconColor: AppColors.tertiary,
                iconBg: AppColors.tertiaryContainer.withOpacity(0.15),
                title: 'Thông tin cá nhân',
                subtitle: 'Tên, ngày sinh, liên hệ',
                onTap: () {},
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.lock_outline,
                iconColor: AppColors.secondary,
                iconBg: AppColors.secondaryContainer.withOpacity(0.2),
                title: 'Đổi mật khẩu',
                subtitle: 'Cập nhật mật khẩu đăng nhập',
                onTap: () {},
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.badge_outlined,
                iconColor: AppColors.primaryContainer,
                iconBg: AppColors.primaryFixed,
                title: 'Thẻ học sinh',
                subtitle: 'Xem và tải thẻ học sinh',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: AppStyles.stackLg),

            // ── Thông báo & Giao diện ─────────────────────────────
            _buildSectionLabel('Thông báo & Giao diện'),
            const SizedBox(height: AppStyles.stackMd),
            _buildSettingsGroup([
              _buildToggleTile(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.error,
                iconBg: AppColors.errorContainer.withOpacity(0.5),
                title: 'Thông báo',
                subtitle: 'Nhận thông báo từ trường',
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
              ),
              _buildDivider(),
              _buildToggleTile(
                icon: Icons.dark_mode_outlined,
                iconColor: const Color(0xFF6750A4),
                iconBg: const Color(0xFFEADDFF),
                title: 'Chế độ tối',
                subtitle: 'Giao diện nền tối',
                value: _darkModeEnabled,
                onChanged: (v) => setState(() => _darkModeEnabled = v),
              ),
              _buildDivider(),
              _buildToggleTile(
                icon: Icons.fingerprint,
                iconColor: AppColors.tertiary,
                iconBg: AppColors.tertiaryContainer.withOpacity(0.15),
                title: 'Xác thực sinh trắc học',
                subtitle: 'Đăng nhập bằng vân tay / Face ID',
                value: _biometricEnabled,
                onChanged: (v) => setState(() => _biometricEnabled = v),
              ),
            ]),
            const SizedBox(height: AppStyles.stackLg),

            // ── Hỗ trợ ───────────────────────────────────────────
            _buildSectionLabel('Hỗ trợ'),
            const SizedBox(height: AppStyles.stackMd),
            _buildSettingsGroup([
              _buildNavTile(
                icon: Icons.help_outline,
                iconColor: AppColors.secondary,
                iconBg: AppColors.secondaryContainer.withOpacity(0.2),
                title: 'Trung tâm hỗ trợ',
                subtitle: 'Câu hỏi thường gặp',
                onTap: () {},
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.contact_support_outlined,
                iconColor: AppColors.tertiary,
                iconBg: AppColors.tertiaryContainer.withOpacity(0.15),
                title: 'Liên hệ nhà trường',
                subtitle: 'Hotline & email hỗ trợ',
                onTap: () {},
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.info_outline,
                iconColor: AppColors.onSurfaceVariant,
                iconBg: AppColors.surfaceContainerLow,
                title: 'Về ứng dụng',
                subtitle: 'Phiên bản 1.0.0',
                onTap: () {},
                showArrow: false,
                trailing: Text(
                  'v1.0.0',
                  style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ]),
            const SizedBox(height: AppStyles.stackLg),

            // ── Đăng xuất ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 58,
              child: OutlinedButton(
                onPressed: _showLogoutDialog,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Đăng xuất',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppStyles.labelLg.copyWith(
        color: AppColors.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: AppStyles.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: Color(0xFFF0F0F0),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.labelLg.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppStyles.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (showArrow && trailing == null)
              const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.labelLg.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppStyles.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryContainer,
          ),
        ],
      ),
    );
  }
}
