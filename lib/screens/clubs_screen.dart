import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../api/club_api.dart';
import '../widgets/custom_app_header.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  final ClubApi _apiController = ClubApi();
  final TextEditingController _searchController = TextEditingController();
  int _activeChipIndex = 0;
  List<ClubModel> _clubs = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _categories = [
    'Tất cả',
    'Công nghệ',
    'Nghệ thuật',
    'Thể thao',
    'Kỹ năng',
  ];

  @override
  void initState() {
    super.initState();
    _fetchClubs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchClubs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final category = _activeChipIndex == 0 ? null : _categories[_activeChipIndex];
      final search = _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null;
      final list = await _apiController.getClubs(category: category, search: search);
      setState(() {
        _clubs = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'developer_board':
        return Icons.developer_board;
      case 'palette':
        return Icons.palette;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'record_voice_over':
        return Icons.record_voice_over;
      default:
        return Icons.groups;
    }
  }

  Color _getAccentColor(String colorName) {
    switch (colorName) {
      case 'primary':
        return AppColors.primary;
      case 'secondary':
        return AppColors.secondary;
      case 'tertiary':
        return AppColors.tertiary;
      case 'error':
        return AppColors.error;
      default:
        return AppColors.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppHeader(
        title: 'Câu lạc bộ',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _fetchClubs,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchClubs,
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
          
          // Header Section
          Text(
            'Câu lạc bộ',
            style: AppStyles.headlineLg.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppStyles.baseSpacing),
          Text(
            'Khám phá và tham gia các hoạt động ngoại khóa sôi nổi tại FPT School.',
            style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppStyles.stackLg),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _fetchClubs(),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm câu lạc bộ...',
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
          const SizedBox(height: AppStyles.stackMd),

          // Category Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_categories.length, (index) {
                final bool isActive = _activeChipIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _activeChipIndex = index);
                      _fetchClubs();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                                  color: const Color(0xffFF9800).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(9999),
                              color: AppColors.surfaceContainerLowest,
                              border: Border.all(color: AppColors.outlineVariant, width: 1),
                            ),
                      child: Text(
                        _categories[index],
                        style: AppStyles.labelLg.copyWith(
                          color: isActive ? Colors.white : AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: AppStyles.stackLg),

          // Clubs list
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
                    ElevatedButton(onPressed: _fetchClubs, child: const Text('Thử lại')),
                  ],
                ),
              ),
            )
          else if (_clubs.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  const Icon(Icons.inbox, size: 48, color: AppColors.outline),
                  const SizedBox(height: 12),
                  Text(
                    'Không tìm thấy câu lạc bộ nào',
                    style: AppStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            )
          else
            ..._clubs.map((club) => Padding(
                  padding: const EdgeInsets.only(bottom: AppStyles.gutter),
                  child: _buildClubCard(
                    title: club.name,
                    tag: club.category,
                    desc: club.description,
                    accentColor: _getAccentColor(club.accentColor),
                    tagBgColor: _getAccentColor(club.accentColor).withOpacity(0.15),
                    tagColor: _getAccentColor(club.accentColor),
                    icon: _getIconData(club.iconName),
                    members: const [],
                    extraMembersCount: club.memberCount,
                  ),
                )),
          
          const SizedBox(height: AppStyles.stackLg),

          // Register Club Suggestion Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: AppStyles.primaryGradientDecoration,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bạn chưa tìm thấy CLB phù hợp?',
                      style: AppStyles.headlineLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tự đề xuất thành lập câu lạc bộ mới của riêng bạn ngay hôm nay!',
                      style: AppStyles.bodyMd.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Đăng ký ngay',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffFF7043),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_rounded, color: Color(0xffFF7043), size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  right: -10,
                  bottom: -15,
                  child: Opacity(
                    opacity: 0.2,
                    child: Icon(
                      Icons.groups,
                      size: 110,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildClubCard({
    required String title,
    required String tag,
    required String desc,
    required Color accentColor,
    required Color tagBgColor,
    required Color tagColor,
    required IconData icon,
    required List<String> members,
    required int extraMembersCount,
  }) {
    return Container(
      decoration: AppStyles.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: tagColor, size: 24),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: AppStyles.labelSm.copyWith(
                          color: tagColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppStyles.headlineMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (members.isNotEmpty)
                          SizedBox(
                            width: members.length * 20.0 + 12.0,
                            height: 32,
                            child: Stack(
                              children: List.generate(members.length, (idx) {
                                return Positioned(
                                  left: idx * 20.0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      image: DecorationImage(
                                        image: NetworkImage(members[idx]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            '+$extraMembersCount',
                            style: AppStyles.labelSm.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'View Detail',
                          style: AppStyles.labelLg.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.arrow_forward, color: AppColors.primary, size: 16),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
