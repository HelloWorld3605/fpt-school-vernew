import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 2; // Wednesday Oct 25 is index 2

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
                      border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5), width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCtPhL0f-45OP0BNeJrOt5PPZH165xwgkBkWbYICWxsUAxsd2Pt_zG_GdmfSz9zrORdd9v7Vm_seGAvcMw3HfbMQVVZwrYgQhsEmmX8GDGwMqQFNKnorCwdM2MEsVLDuM7j8Ip--f2z2BGp0Rz3XICG9wkYccyGFsWTsjQKrs7MeDvTOzuDHQLOc0tCB1GevBula8CQW35m1DPtMc_o5L_mJiA380kilKpgDVGBsxgQdjnW86YLpamFJzLiGeRLTHYB1pzGqgVMeLwX',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'FPT SCHOOL',
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
                        'Tháng 10, 2023',
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppColors.primaryContainer : Colors.transparent,
                            boxShadow: isSelected
                                ? const [
                                    BoxShadow(
                                      color: Color(0x40FF6B00),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : null,
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

            // Timeline Card 1
            _buildClassCard(
              ca: 'CA 1 (07:30 - 09:00)',
              accentColor: AppColors.secondary, // blue border
              subject: 'Lập trình Java Nâng cao',
              room: 'Phòng AL-L204',
              teacherName: 'GV. Nguyễn Văn A',
              teacherImg: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDj1YZaPDuIZuwPP2VYM-YTmvJ8tqJ4v7vd7pXDlXjpd0gGIDbEvHcw6T5X0tfQrNTU_4_betZrOAqlNg4nyNSWKarZaF4o4xW6-LuaXjyFdrRz-I7LiRVPJMurFdTPOtsRXCdhV2z2hl202WZgcaa2dhqWJARZE3hZVnVGnUqzJH0Heaetm7wMYcP3pBn6JBC60FoLNaRpN1i0L8760Dre_DgUM13PdcE_O0boeGi42D1DBe5bXs3nsWHJxhBqNAn-Olkf1TD2oaVi',
              status: 'Đang diễn ra',
              statusBg: AppColors.surfaceContainerHigh,
              statusText: AppColors.onSecondaryContainer,
            ),
            const SizedBox(height: AppStyles.gutter),

            // Timeline Card 2
            _buildClassCard(
              ca: 'CA 2 (09:15 - 10:45)',
              accentColor: AppColors.tertiary, // medium blue border
              subject: 'Cấu trúc dữ liệu & Giải thuật',
              room: 'Phòng BE-301',
              teacherName: 'GV. Trần Thị B',
              teacherImg: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDbSaQYDs2MGMey3F7pwBkHz_p8vMtSa1px72aMLU-MTk7Oa_ttg0bU_zI_MxoslOqHpo3WsoyZ9Ax1CSXVZ4SjU_BzOpXaZ-es_yZ25hQLljEz7WtdvjIl7gq34A7xOjD4gBKZIbHUY9RAMAIYazyOvyGwVx5aGBuhvoczKIZC9ipKxCDYS-_DUKLOredyIim6PlopcKEtBhkAD9t8xr1Sr0b66zFZUI7v8yCfXOK3IChlGR3SbTB1nvjQndNXJTJZiPnV2RcR5YeK',
              status: 'Sắp tới',
              statusBg: AppColors.surfaceContainerLow,
              statusText: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppStyles.gutter),

            // Timeline Card 3
            _buildClassCard(
              ca: 'CA 4 (13:30 - 15:00)',
              accentColor: AppColors.primary, // orange border
              subject: 'Tiếng Anh Giao tiếp 3',
              room: 'Phòng AL-H102',
              teacherName: 'GV. Chris Johnson',
              teacherImg: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAkqn6Y5DXGIoqtJuGh4i64J5V0Wtayrx5k6DsjsTXdmm1utRURz_JW-J6LYNePv38UKTZsCCkbPQBI_Mo-g4MWLcjvAuXDvJRP3d87bn5aSL9RHX-wW9MPr7B4eSZ39eDN2vaC2HHUHjvNjUtmyI0nlQYC_nUuQgHwoHOVhGvXf6IwiFAncZh5FVzJoZdDxMabajOHy9vCeE9X69_PpCAZK9ZsyMQ58d_5eyvuqr3hzqKvLQXhqorBugcF9wxymnExmNn7VwspbYkk',
              status: 'Sắp tới',
              statusBg: AppColors.surfaceContainerLow,
              statusText: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Tasks & Notes Section
            Text(
              'Ghi chú & Bài tập',
              style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppStyles.stackMd),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed, // peach bg
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.assignment, color: AppColors.onPrimaryFixed, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          'Deadline Java Assignment 2',
                          style: AppStyles.labelLg.copyWith(
                            color: AppColors.onPrimaryFixed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hôm nay, 23:59',
                          style: AppStyles.labelSm.copyWith(
                            color: AppColors.onPrimaryFixedVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppStyles.gutter),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryFixed, // light blue bg
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.group, color: AppColors.onSecondaryFixed, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          'Họp nhóm DSA',
                          style: AppStyles.labelLg.copyWith(
                            color: AppColors.onSecondaryFixed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Thứ 5, 15:30',
                          style: AppStyles.labelSm.copyWith(
                            color: AppColors.onSecondaryFixedVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 120), // Spacer for bottom navigation
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryContainer,
        shape: const CircleBorder(),
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
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
