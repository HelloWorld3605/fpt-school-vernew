import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../api/event_api.dart';
import '../api/auth_api.dart';
import '../widgets/custom_app_header.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventApi _apiController = EventApi();
  final TextEditingController _searchController = TextEditingController();
  List<EventModel> _events = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final studentId = AuthApi.currentUser?.studentId;
      final keyword = _searchController.text.trim();
      List<EventModel> list;
      if (keyword.isNotEmpty) {
        list = await _apiController.searchEvents(keyword);
      } else {
        list = await _apiController.getAllEvents(studentId: studentId);
      }
      setState(() {
        _events = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleRegistration(EventModel event) async {
    final studentId = AuthApi.currentUser?.studentId;
    if (studentId == null) {
      _showSnackBar('Bạn cần đăng nhập để thực hiện chức năng này');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool success;
    if (event.isRegistered) {
      success = await _apiController.unregisterEvent(event.eventId, studentId);
      if (success) {
        _showSnackBar('Đã hủy đăng ký sự kiện thành công');
      } else {
        _showSnackBar('Hủy đăng ký thất bại');
      }
    } else {
      success = await _apiController.registerEvent(event.eventId, studentId);
      if (success) {
        _showSnackBar('Đăng ký tham gia sự kiện thành công!');
      } else {
        _showSnackBar('Đăng ký thất bại');
      }
    }

    _fetchEvents();
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppHeader(
        title: 'Sự kiện',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _fetchEvents,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchEvents,
        color: AppColors.primary,
        child: _buildBodyContent(),
      ),
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
              controller: _searchController,
              onSubmitted: (_) => _fetchEvents(),
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
                    ElevatedButton(onPressed: _fetchEvents, child: const Text('Thử lại')),
                  ],
                ),
              ),
            )
          else if (_events.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  const Icon(Icons.inbox, size: 48, color: AppColors.outline),
                  const SizedBox(height: 12),
                  Text(
                    'Không tìm thấy sự kiện nào',
                    style: AppStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            )
          else
            ..._events.asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;

              Color leftBorder = AppColors.tertiaryContainer;
              Color tagBg = AppColors.tertiary;
              if (index % 3 == 1) {
                leftBorder = AppColors.primaryContainer;
                tagBg = AppColors.primary;
              } else if (index % 3 == 2) {
                leftBorder = AppColors.secondaryContainer;
                tagBg = AppColors.secondary;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppStyles.gutter),
                child: _buildEventCard(
                  event: event,
                  leftBorderColor: leftBorder,
                  tagBgColor: tagBg,
                ),
              );
            }),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required EventModel event,
    required Color leftBorderColor,
    required Color tagBgColor,
  }) {
    DateTime? date = DateTime.tryParse(event.eventDate);
    String dateDay = date != null ? date.day.toString() : '15';
    String dateMonth = date != null ? 'Th${date.month.toString().padLeft(2, '0')}' : 'Th08';

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
                        event.imageUrl,
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
                            event.tag,
                            style: AppStyles.labelSm.copyWith(
                              color: Colors.white,
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
                                event.title,
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
                                event.location,
                                style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Time row
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule, 
                              color: AppColors.onSurfaceVariant, 
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                event.timeInfo,
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
                          child: !event.hasRegistration
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
                                  decoration: event.isRegistered
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
                                    onPressed: () => _toggleRegistration(event),
                                    style: AppStyles.gradientButtonStyle,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          event.isRegistered ? 'Đã đăng ký!' : 'Tham gia ngay',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          event.isRegistered ? Icons.check_rounded : Icons.arrow_forward_rounded,
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
