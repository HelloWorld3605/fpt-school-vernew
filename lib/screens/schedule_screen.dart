import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../api/schedule_api.dart';
import '../api/auth_api.dart';
import '../widgets/custom_app_header.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleApi _apiController = ScheduleApi();
  int _selectedDayIndex = 2; // Wednesday Oct 25 is index 2
  List<ScheduleItem> _scheduleItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<Map<String, String>> _days = [
    {'label': 'T2', 'date': '23'},
    {'label': 'T3', 'date': '24'},
    {'label': 'T4', 'date': '25'},
    {'label': 'T5', 'date': '26'},
    {'label': 'T6', 'date': '27'},
    {'label': 'T7', 'date': '28'},
    {'label': 'CN', 'date': '29'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final studentId = AuthApi.currentUser?.studentId ?? 'HS001';
      final dayOfWeek = _selectedDayIndex + 2; // 0 (Mon) + 2 = 2
      final items = await _apiController.getScheduleByDay(studentId, dayOfWeek);
      setState(() {
        _scheduleItems = items;
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
        title: 'Thời khóa biểu',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _fetchSchedule,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchSchedule,
        color: AppColors.primary,
        child: _buildBodyContent(),
      ),
      floatingActionButton: null,
    );
  }

  Widget _buildBodyContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppStyles.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppStyles.stackLg),
          
          // Week Selector Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tuần này',
                style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'Học kỳ 2 - 2023-2024',
                      style: AppStyles.labelLg.copyWith(color: AppColors.primary),
                    ),
                    const Icon(Icons.expand_more, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.stackMd),
          
          // Days selector
          Container(
            padding: const EdgeInsets.all(12),
            decoration: AppStyles.cardDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_days.length, (index) {
                final day = _days[index];
                final bool isSelected = _selectedDayIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                    _fetchSchedule();
                  },
                  child: Column(
                    children: [
                      Text(
                        day['label']!,
                        style: AppStyles.labelSm.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: isSelected
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xffFFA726), Color(0xffFF7043)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xffFF9800).withOpacity(0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              )
                            : const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                        alignment: Alignment.center,
                        child: Text(
                          day['date']!,
                          style: AppStyles.labelLg.copyWith(
                            color: isSelected ? Colors.white : AppColors.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: AppStyles.stackLg),

          // Schedule Timeline header
          Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: 8),
              Text(
                'Lịch học chi tiết',
                style: AppStyles.labelLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.stackMd),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            )
          else if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.cloud_off, size: 48, color: AppColors.outline),
                    const SizedBox(height: 8),
                    Text('Lỗi kết nối máy chủ', style: AppStyles.labelLg),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _fetchSchedule, child: const Text('Thử lại')),
                  ],
                ),
              ),
            )
          else if (_scheduleItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  const Icon(Icons.inbox, size: 48, color: AppColors.outline),
                  const SizedBox(height: 12),
                  Text(
                    'Không có lịch học trong ngày này',
                    style: AppStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            )
          else
            ..._scheduleItems.map((item) {
              Color borderAccent;
              if (item.periodName.contains('1')) {
                borderAccent = AppColors.secondary;
              } else if (item.periodName.contains('2')) {
                borderAccent = AppColors.tertiary;
              } else {
                borderAccent = AppColors.primary;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppStyles.gutter),
                child: _buildClassCard(
                  ca: '${item.periodName} (${item.startTime} - ${item.endTime})',
                  accentColor: borderAccent,
                  subject: item.subjectName,
                  room: item.room,
                  teacherName: item.teacherName,
                  teacherImg: item.teacherImg.isNotEmpty
                      ? item.teacherImg
                      : 'https://lh3.googleusercontent.com/aida-public/AB6AXuDl_VHMDx1JShY3SNjxG-7jzebA66QCJXdl2eUw_nI7cZWJib1d3-XBzvVJ5wikjqBEo5CzmK8CtRJIjESY2hIUaRY315SYZTA9tXi6kQKNqt2PwcVszhptNKippCOUU1_6NQY-O0XF_J-73FmaDmtML14gIHvkvkZdQYhCVs1FWzUZ1k9CMUCzWC9i8m308SI9ql3lmsbJ7_GSZo-XINPj_7eJTqFlxebVCr3sv6nUvAc61972-wkPLHMPBERIRwdtJI1nquhZw_Vi',
                  status: item.status,
                  statusBg: item.status == 'Đang diễn ra' ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLow,
                  statusText: item.status == 'Đang diễn ra' ? AppColors.onSecondaryContainer : AppColors.onSurfaceVariant,
                ),
              );
            }),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildClassCard({
    required String ca,
    required Color accentColor,
    required String subject,
    required String room,
    required String teacherName,
    required String teacherImg,
    required String status,
    required Color statusBg,
    required Color statusText,
  }) {
    return Container(
      decoration: AppStyles.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              color: accentColor,
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
                                ca,
                                style: AppStyles.labelSm.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subject,
                                style: AppStyles.headlineMd.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: AppStyles.labelSm.copyWith(
                              color: statusText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.onSurfaceVariant, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          room,
                          style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.outlineVariant, width: 1),
                            image: DecorationImage(
                              image: NetworkImage(teacherImg),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          teacherName,
                          style: AppStyles.bodyMd.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w500,
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
