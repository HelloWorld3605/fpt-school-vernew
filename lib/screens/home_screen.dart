import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import 'navigation_shell.dart';
import 'events_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryContainer, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDl_VHMDx1JShY3SNjxG-7jzebA66QCJXdl2eUw_nI7cZWJib1d3-XBzvVJ5wikjqBEo5CzmK8CtRJIjESY2hIUaRY315SYZTA9tXi6kQKNqt2PwcVszhptNKippCOUU1_6NQY-O0XF_J-73FmaDmtML14gIHvkvkZdQYhCVs1FWzUZ1k9CMUCzWC9i8m308SI9ql3lmsbJ7_GSZo-XINPj_7eJTqFlxebVCr3sv6nUvAc61972-wkPLHMPBERIRwdtJI1nquhZw_Vi',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Xin chào,',
                        style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        'Lê Văn A',
                        style: AppStyles.headlineMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_outlined, color: AppColors.onSurfaceVariant),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppStyles.stackLg),
            
            // Bento Hero Section
            // GPA Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: AppStyles.orangeGradientDecoration,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Điểm trung bình học kỳ',
                        style: AppStyles.labelLg.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '8.4 / 10',
                        style: AppStyles.display.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Học kỳ 1 • 2023-2024',
                          style: AppStyles.labelSm.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const Positioned(
                    right: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.school,
                        size: 96,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.gutter),

            // Next Class & Event Grid
            Row(
              children: [
                // Next Class Card
                Expanded(
                  child: Container(
                    height: 160,
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Tiết học kế',
                                  style: AppStyles.labelSm.copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Toán Cao Cấp 1',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.labelLg.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Phòng A.201',
                              style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        Text(
                          '09:30 AM',
                          style: AppStyles.labelSm.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppStyles.gutter),

                // Event Highlight Card
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EventsScreen()),
                      );
                    },
                    child: Container(
                      height: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: AppStyles.cardDecoration.copyWith(
                        color: AppColors.tertiaryContainer, // #059eff
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Sắp diễn ra',
                                      style: AppStyles.labelSm.copyWith(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'FU Tech Day 2024',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.labelLg.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Thứ 6, 24/05',
                                style: AppStyles.labelSm.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          const Positioned(
                            right: -10,
                            bottom: -10,
                            child: Opacity(
                              opacity: 0.2,
                              child: Icon(
                                Icons.celebration,
                                size: 56,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Quick Actions Section
            Text(
              'Chức năng chính',
              style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppStyles.stackSm),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildQuickAction(context, 1, Icons.calendar_month, 'Lịch học'),
                _buildQuickAction(context, 2, Icons.grading, 'Điểm'),
                _buildQuickAction(context, 3, Icons.description, 'Đơn từ'),
                _buildQuickAction(context, 4, Icons.groups, 'CLB'),
              ],
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Notifications Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thông báo mới',
                  style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Xem tất cả',
                    style: AppStyles.labelLg.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.stackSm),
            _buildNotificationItem(
              icon: Icons.info,
              iconColor: Colors.blue.shade600,
              bgColor: Colors.blue.shade50,
              title: 'Thông báo nộp học phí',
              desc: 'Hạn cuối nộp học phí học kỳ Fall 2024 là ngày 30/08/2024. Vui lòng kiểm tra...',
              time: '2 giờ trước',
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.campaign,
              iconColor: AppColors.primary,
              bgColor: Colors.orange.shade50,
              title: 'Lễ hội âm nhạc Summer 2024',
              desc: 'Cùng bùng nổ với các nghệ sĩ khách mời tại sân vận động FPT Polytechnic vào tối thứ 7...',
              time: '1 ngày trước',
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Featured News Section
            Text(
              'Tin tức nổi bật',
              style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppStyles.stackSm),
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildNewsCard(
                    imgUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC4Sfnsp8Cc9D8iuxxgRPQYH8oLZkpIAKGI3tu9Nkjfyv9DpgLmp-cFfNJt6QWlK4vJiBJ_QDsSh4ShE6dzt4wO91bXVWckKYrlp8YUYmDkWemjbPc6b2KR1LXJYkLiTfWKJol7aEzoIcmSKP6QADJYncKcKYzC-R7F47u-Pnwr-IjMed2ffLdu45DpdxrheXveiq2BxxhqpTpwp_0owAFN2oC1zhEj9Z5LmpZsUujp7rHZnuTsjSzJdbCbhdqVRx9IM22cGr8f24sP',
                    category: 'HỌC THUẬT',
                    categoryColor: AppColors.primary,
                    title: 'FPT School vinh danh 100 sinh viên xuất sắc',
                  ),
                  const SizedBox(width: 16),
                  _buildNewsCard(
                    imgUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC0-w-z0nna6BJzF2z4ZtHZEXE4mpax0F6REuq2XfkgiKHreN1yUw1Lv_ba_Wa5sEOgq6iBYs_Yq7pwGyvzG5a2I7qNenhYfO2WPtTrCDTugoglSjOKcC8zTZ0gSxgQuQNH8qGFkoULAGFBM50oQKFoSc3qZUCklk82Arj-XGBllEt9y8LrfVkwRGgyVHz0qj1otdWBFBj6P0JekMOOL17-k3Y6YKhmefKsjOo4NUWn3lWzw9u2P5SCTxX5DeqJT0N_RPDeRM5Vc4fH',
                    category: 'SINH VIÊN',
                    categoryColor: AppColors.tertiary,
                    title: 'Khám phá không gian tự học mới tại tòa nhà Gamma',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120), // Spacer for bottom navigation
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 6,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, int tabIndex, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        NavigationShellController.navigateTo(context, tabIndex);
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.outlineVariant.withOpacity(0.3),
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String desc,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppStyles.labelLg.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String imgUrl,
    required String category,
    required Color categoryColor,
    required String title,
  }) {
    return Container(
      width: 256,
      decoration: AppStyles.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imgUrl,
            height: 128,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 128,
              color: AppColors.surfaceContainerHigh,
              child: const Icon(Icons.broken_image, color: AppColors.outline),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: AppStyles.labelSm.copyWith(
                    color: categoryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.labelLg.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
