import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class FormsScreen extends StatelessWidget {
  const FormsScreen({super.key});

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
                      border: Border.all(color: AppColors.primary, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD17d2SgSpFR2-mVFs8s0_KSbZgw0yU7U0SDqCx6CZCvSbN21oMbX0C0PN5CtEs00UN4_thawIYofsO6psk7bmWqOWB1RKq9zBPXq0zBQxFZBKOyBDQsSBzwKVoXPu3UlNcpjIRVjoyDft8otSja73YXGOKOsng4yi5eH6NYITHWx11heopc7O_LbWfvGugRJQLeTAtIs-9ihVQD1oRu84KsS6f0UirPDjSpMomk7inxQON7dBSUDvgV23O59NnnI1sPMFcKpQ__Sd1',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Đơn từ',
                    style: AppStyles.headlineMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: AppColors.onSurfaceVariant),
                onPressed: () {},
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
            
            // Support Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33FF6B00),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hệ thống hỗ trợ',
                        style: AppStyles.labelLg.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gửi yêu cầu hành chính trực tuyến',
                        style: AppStyles.display.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nhanh chóng, minh bạch và dễ dàng theo dõi tiến độ xử lý.',
                        style: AppStyles.bodyMd.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const Positioned(
                    right: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: 0.2,
                      child: Icon(
                        Icons.description,
                        size: 96,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Categories Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh mục',
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
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildCategoryCard(
                    icon: Icons.school,
                    iconColor: Colors.blue.shade600,
                    bgColor: Colors.blue.shade50,
                    title: 'Học thuật',
                  ),
                  const SizedBox(width: 16),
                  _buildCategoryCard(
                    icon: Icons.account_balance,
                    iconColor: AppColors.primary,
                    bgColor: Colors.orange.shade50,
                    title: 'Hành chính',
                  ),
                  const SizedBox(width: 16),
                  _buildCategoryCard(
                    icon: Icons.payments,
                    iconColor: Colors.green.shade600,
                    bgColor: Colors.green.shade50,
                    title: 'Tài chính',
                  ),
                  const SizedBox(width: 16),
                  _buildCategoryCard(
                    icon: Icons.apartment,
                    iconColor: Colors.purple.shade600,
                    bgColor: Colors.purple.shade50,
                    title: 'Cơ sở vật chất',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Active Requests (Đơn đã gửi)
            Text(
              'Đơn đã gửi',
              style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppStyles.stackMd),
            
            // Request Card 1
            _buildRequestCard(
              title: 'Đơn xin nghỉ học tạm thời',
              code: '#RQ-8821',
              status: 'Đang xử lý',
              statusColor: Colors.yellow.shade800,
              statusBg: Colors.yellow.shade100,
              leftBorderColor: Colors.blue.shade500,
              date: '24/05/2024',
              department: 'Phòng Đào tạo',
            ),
            const SizedBox(height: AppStyles.gutter),

            // Request Card 2
            _buildRequestCard(
              title: 'Cấp lại thẻ sinh viên',
              code: '#RQ-7712',
              status: 'Đã phê duyệt',
              statusColor: Colors.green.shade800,
              statusBg: Colors.green.shade100,
              leftBorderColor: Colors.green.shade500,
              date: '20/05/2024',
              department: 'Phòng Công tác SV',
            ),
            const SizedBox(height: AppStyles.gutter),

            // Request Card 3
            _buildRequestCard(
              title: 'Đăng ký mượn hội trường',
              code: '#RQ-9010',
              status: 'Mới tạo',
              statusColor: AppColors.onSurfaceVariant,
              statusBg: AppColors.surfaceContainerHigh,
              leftBorderColor: AppColors.primary,
              date: 'Hôm nay',
              department: 'Ban Quản lý CSVC',
            ),
            const SizedBox(height: 120), // Spacer for bottom navigation
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
  }) {
    return Container(
      width: 128,
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.labelLg.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required String title,
    required String code,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required Color leftBorderColor,
    required String date,
    required String department,
  }) {
    return Container(
      decoration: AppStyles.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              color: leftBorderColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: AppStyles.labelLg.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Mã đơn: $code',
                                style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: AppStyles.labelSm.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: AppColors.outlineVariant.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppColors.onSurfaceVariant, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              date,
                              style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  department,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
