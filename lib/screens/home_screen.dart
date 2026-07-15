import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import 'navigation_shell.dart';
import 'events_screen.dart';
import 'notifications_screen.dart';
import '../api/home_api.dart';
import '../api/auth_api.dart';
import '../widgets/custom_app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeApi _homeApiController = HomeApi();
  HomeData? _homeData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final studentId = AuthApi.currentUser?.studentId ?? 'HS001';
      final data = await _homeApiController.getHomeData(studentId);
      setState(() {
        _homeData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppHeader(
        title: 'FPT School',
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: AppColors.onSurfaceVariant),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                },
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
      body: RefreshIndicator(
        onRefresh: _fetchHomeData,
        color: AppColors.primary,
        child: _buildBodyContent(),
      ),
      floatingActionButton: null,
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 72, color: AppColors.outline),
              const SizedBox(height: 16),
              Text(
                'Không Thể Kết Nối Máy Chủ',
                style: AppStyles.headlineLg.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchHomeData,
                icon: const Icon(Icons.sync),
                label: const Text('Thử Lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final data = _homeData!;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppStyles.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppStyles.stackLg),
          
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
                      '${data.gpaAverage.toStringAsFixed(1)} / 10',
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
                        data.gpaSemester,
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
                            data.nextClass?.subjectName ?? 'Không có lịch học',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.labelLg.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.nextClass?.room ?? '',
                            style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      Text(
                        data.nextClass?.startTime ?? '--:--',
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
                      color: AppColors.tertiaryContainer,
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
                                  data.upcomingEvent?.title ?? 'Không có sự kiện',
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
                              data.upcomingEvent?.eventDate ?? '',
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                },
                child: Text(
                  'Xem tất cả',
                  style: AppStyles.labelLg.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.stackSm),
          if (data.notifications.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: AppStyles.cardDecoration,
              child: Center(
                child: Text(
                  'Không có thông báo nào',
                  style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            )
          else
            ...data.notifications.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildNotificationItem(
                    icon: n.iconType == 'campaign' ? Icons.campaign : Icons.info,
                    iconColor: n.iconType == 'campaign' ? AppColors.primary : Colors.blue.shade600,
                    bgColor: n.iconType == 'campaign' ? Colors.orange.shade50 : Colors.blue.shade50,
                    title: n.title,
                    desc: n.description,
                    time: n.timeAgo,
                  ),
                )),
          const SizedBox(height: AppStyles.stackLg),

          // Featured News Section
          Text(
            'Tin tức nổi bật',
            style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppStyles.stackSm),
          if (data.news.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: AppStyles.cardDecoration,
              child: Center(
                child: Text(
                  'Không có tin tức nào',
                  style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            )
          else
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: data.news.length,
                itemBuilder: (context, index) {
                  final nw = data.news[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildNewsCard(
                      imgUrl: nw.imageUrl,
                      category: nw.category,
                      categoryColor: index % 2 == 0 ? AppColors.primary : AppColors.tertiary,
                      title: nw.title,
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 120),
        ],
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
