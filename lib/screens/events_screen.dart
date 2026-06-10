import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final Map<String, bool> _registeredEvents = {};

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
            12,
            MediaQuery.of(context).padding.top + 8,
            AppStyles.containerPadding,
            8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryFixed, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD1VzPafBGO-KDwKhTmXZNMsfaTqXHeqvtYqBw5kEOB7bUi0QabYULFdcQqhwOtmjYb_aGN3AIa2kD7ZWAjLx6ZSVYBB2xPUFhr6O2QNms94o2H-JFOdUshb_iulXgu56weZaRcLOPceY8NJn2VrfBJ9dHbYmyEnqfLD56sVOiuQurpGjbCO0SaZx9Aq2lA73J0TDnB_Qn-7l1Jo6zovLxPgt4-D8gDyMKAdhwps3j86HyEXEh5-JFjMa_4Y6JJ2Mygfuo_dX9_JIYm',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                icon: const Icon(Icons.notifications_none_outlined, color: AppColors.primary),
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
            
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sự kiện, hoạt động...',
                  hintStyle: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryContainer),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primaryContainer, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Welcome/Header Text
            Text(
              'Sự kiện sắp tới',
              style: AppStyles.headlineLg.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppStyles.baseSpacing),
            Text(
              'Khám phá các hoạt động ngoại khóa và học thuật mới nhất tại FPT School.',
              style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Events Bento Cards List
            // Event 1
            _buildEventCard(
              id: 'event_1',
              title: 'Hội thảo AI & Tương lai Giáo dục',
              tag: 'Học thuật',
              tagColor: Colors.white,
              tagBgColor: AppColors.tertiary,
              leftBorderColor: AppColors.tertiaryContainer, // #059eff border left
              dateDay: '15',
              dateMonth: 'Th08',
              location: 'Hội trường Alpha, Tầng 3',
              time: '08:00 - 11:30',
              imgUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDGo7E6sFfT2YstDDKwibKPBqWtU0N3ONL4bAgCrPSmAHvHebhTqxKRrB_P6Ze4Ca4VTKvZRtdrJwBhoOFHfgBGMoot5F9rX37bE6FtG1Jx5tQ03tfleiT6fEcAsfdSduAggU0HAgIwI7MBcT9UTE9C461f2iUnXBvnKHw9MGaB9e1uuNBObq05AJ_9qIihYdFwE0vAlDE2SkXW69YDalt3EIRd1OsoqOIye1zA5QgmujXNZucjxwFgpEwa1RWxbE-lcwjPUeR06Lgz',
              hasDetailsBtnOnly: false,
            ),
            const SizedBox(height: AppStyles.gutter),

            // Event 2
            _buildEventCard(
              id: 'event_2',
              title: 'Ngày hội Văn hóa FPT Spirit',
              tag: 'Lễ hội',
              tagColor: Colors.white,
              tagBgColor: AppColors.primary,
              leftBorderColor: AppColors.primaryContainer, // #ff6b00 border left
              dateDay: '22',
              dateMonth: 'Th08',
              location: 'Sân vận động FPT',
              time: '14:00 - 21:00',
              imgUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDBGlDfpjz991FAQpWrnMnPa10Bx5ocDmZoaFmMC0e0eflb5A_UTDEzXRLy2V9-TwO3iwhVC8pyqAJxwMakODEp78GPO48qyeZVHJUdar_a211E7_2DQiA_A_RdnS9F1B8fQG7Ef_CuMkfEEzArASGCN-eJRp_51CKuUe0sm_n_v4RE8Xq3AEDsSPCdH054VIsOhcs4qAuD_QdSCW9-M18zu7pPmr-cnjI1-6Jrl9BhsZ4GP5vshSVR5TgEckAAtpV9nvu7jjBBskA0',
              hasDetailsBtnOnly: true,
            ),
            const SizedBox(height: AppStyles.gutter),

            // Event 3
            _buildEventCard(
              id: 'event_3',
              title: 'Workshop Nhiếp ảnh Sáng tạo',
              tag: 'Câu lạc bộ',
              tagColor: Colors.white,
              tagBgColor: AppColors.secondary,
              leftBorderColor: AppColors.secondaryContainer, // #629afe border left
              dateDay: '25',
              dateMonth: 'Th08',
              location: 'Phòng Multimedia 1',
              time: 'Còn 12 chỗ trống',
              imgUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBnuLSiHjoIimfiuDA4noa7kWfzXIfF347Sc36JvYNRj6QXVXnRl_jLunyvAqTh8Ya9nZdTBqylIl0XEVVQtuqOLNuA853mzFLz9TGXqo21i--5S-P3_kMZ2w4mXYZvBSg7KCPI4x94eYfxJhn_PxB615_GKY9A2e16dlkbr3tOvFwbjE_yXTg6hLNkRT3XBjqkLEEymKt0VcHDEGngbAWcGGyVcJ90IIZqEBBxXV5_oamj8A0SinwRuBVjT2Ta7RB61Mbu7EzfIKdC',
              hasDetailsBtnOnly: false,
              isLocationStatus: true,
            ),
            const SizedBox(height: 120), // Spacer
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String id,
    required String title,
    required String tag,
    required Color tagColor,
    required Color tagBgColor,
    required Color leftBorderColor,
    required String dateDay,
    required String dateMonth,
    required String location,
    required String time,
    required String imgUrl,
    required bool hasDetailsBtnOnly,
    bool isLocationStatus = false,
  }) {
    final bool isRegistered = _registeredEvents[id] ?? false;

    return Container(
      decoration: AppStyles.cardDecoration.copyWith(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              color: leftBorderColor,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image header
                  Stack(
                    children: [
                      Image.network(
                        imgUrl,
                        height: 192,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 192,
                          color: AppColors.surfaceContainerHigh,
                          child: const Icon(Icons.broken_image, color: AppColors.outline, size: 48),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: tagBgColor,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            tag,
                            style: AppStyles.labelSm.copyWith(
                              color: tagColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Card details
                  Padding(
                    padding: const EdgeInsets.all(20),
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
                                style: AppStyles.headlineMd.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  dateDay,
                                  style: AppStyles.headlineMd.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  dateMonth,
                                  style: AppStyles.labelSm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Location row
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.onSurfaceVariant, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                location,
                                style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Time row
                        Row(
                          children: [
                            Icon(
                              isLocationStatus ? Icons.group : Icons.schedule, 
                              color: AppColors.onSurfaceVariant, 
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                time,
                                style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Button row
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: hasDetailsBtnOnly
                              ? OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primaryContainer,
                                    side: const BorderSide(color: Color(0xffFFA726), width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Xem chi tiết',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.arrow_forward_rounded, size: 18),
                                    ],
                                  ),
                                )
                              : DecoratedBox(
                                  decoration: isRegistered
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.green.shade600,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        )
                                      : AppStyles.gradientButtonDecoration,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _registeredEvents[id] = !isRegistered;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            !isRegistered
                                                ? 'Đăng ký thành công!'
                                                : 'Đã hủy đăng ký.',
                                          ),
                                          backgroundColor: !isRegistered ? Colors.green : Colors.grey,
                                        ),
                                      );
                                    },
                                    style: AppStyles.gradientButtonStyle,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isRegistered ? 'Đã đăng ký!' : 'Tham gia ngay',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          isRegistered ? Icons.check_rounded : Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
