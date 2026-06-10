import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  int _activeChipIndex = 0;
  final List<String> _categories = [
    'Tất cả',
    'Công nghệ',
    'Nghệ thuật',
    'Thể thao',
    'Kỹ năng',
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
                      border: Border.all(color: AppColors.primaryContainer, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDIoZyg0rzyaYKuoOTnbhYUo4ejXsh4SyOaBRA2ziuWkG2pNHhpks8XXSmRWBgduqrC0H33p4gl5AE-LQkYpkLdIptHkw0ExzEWcnuGN4Mr6Xd3KX-H0DIAQ2cea8CQo0NHk4zrY5wEAaj1X7E3U-77bjdpKrTk2y_Z0E0sy7Jbogg-zLiQzKfhXAyo7PombQ4GX1UN8v5vac2hucwzpFlOnx0rpu-D9tTDNadSONqfBlrvpskgj91KeC13x8se5ke4ZeLauVoFcKrv',
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
              decoration: AppStyles.cardDecoration,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm câu lạc bộ...',
                  hintStyle: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  prefixIcon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
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
                    child: ChoiceChip(
                      label: Text(_categories[index]),
                      selected: isActive,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceContainerLowest,
                      labelStyle: AppStyles.labelLg.copyWith(
                        color: isActive ? Colors.white : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                        side: BorderSide(
                          color: isActive ? Colors.transparent : AppColors.outlineVariant,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        setState(() {
                          _activeChipIndex = index;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Clubs list (Bento items)
            Column(
              children: [
                // Club 1
                _buildClubCard(
                  title: 'F-Tech Club',
                  tag: 'Công nghệ',
                  desc: 'Sân chơi dành cho những tín đồ đam mê lập trình, robot và các giải pháp công nghệ sáng tạo.',
                  accentColor: AppColors.tertiaryContainer, // #059eff border left
                  tagBgColor: AppColors.tertiaryContainer.withOpacity(0.1),
                  tagColor: AppColors.tertiary,
                  icon: Icons.developer_board,
                  members: const [
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDDyEFPJ71UMG4P_ScJMW744LpSCdjJzEDqfU4D-71VgnNXsa7vsXf3X4aOQAB9NuCW-r7bZwes3G15PYxIR1H0OH3oilmazsPfBZqLccgHjS3X2gsHAmhvCXJTHFJ4sf1lFKf5jrg3ZoacajiQ_ylFaD4s-AcQxxUj1THF7glPUjG05QF4JyYhIeVENZb1d2tPy-aM_FjLIRQCp_kmEYRyb6jk7DCtHZFkWkZ8nCcQUV0tYzbUqvqS3SaLr6WrjbqKKSM1uTZPlxig',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAv0fU1lirZoSm-Q1DAVjqVDJikBNldPNitmVkyHeDN6an1h28xEC_BHuVsKhu5mHdKbz2pjK513YELHPWg74UGcSeDRGyJkHWnIGIu-jda3dM14ME9hLS_1Rzu_2-dpl2g_DPZVfff_llw2IFX7-FCxtuDRFUBtcdpdkGKcSDmPwtqCT8IQYiTSwOixSuMDgXFgraeskStBg-3evuM46wWeqNq-89Mu7AlWORvBa-TflYb2WFpmV6BXtaW3Jt9mOnk225tA_cJsF4k',
                  ],
                  extraMembersCount: 45,
                ),
                const SizedBox(height: AppStyles.gutter),

                // Club 2
                _buildClubCard(
                  title: 'F-Art Space',
                  tag: 'Nghệ thuật',
                  desc: 'Nơi hội tụ những tâm hồn nghệ thuật, từ hội họa, thiết kế đến âm nhạc và biểu diễn sân khấu.',
                  accentColor: AppColors.error, // red border left
                  tagBgColor: AppColors.errorContainer.withOpacity(0.5),
                  tagColor: AppColors.error,
                  icon: Icons.palette,
                  members: const [
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBkLN1R-eHhO6rxbo81RY2qA_6OXHfunPQvxHOVA0eKRGJafdlxpCE8IJdzc7x9HNEUzHdAr84HR_IyRMhAtLU9YswOo9zYPtH-obAT3g-w5vhAAs-SHj57OR0GQiHbIHCdv-8UxGawfciDFmcAdg5UBsr0yK9K9AndkOSQG7xeeCB_6R7sKPPqg2Tvefl40IUvuuy8deZMz-x8M5vKgyvEw-81Tw53gEiQdOGo2jwK_CfX0XKUkLdKb91plZuHLO0dZNNzAfwhyfy-',
                  ],
                  extraMembersCount: 120,
                ),
                const SizedBox(height: AppStyles.gutter),

                // Club 3
                _buildClubCard(
                  title: 'F-Sport Hub',
                  tag: 'Thể thao',
                  desc: 'Rèn luyện sức khỏe và tinh thần đồng đội thông qua các bộ môn bóng rổ, bóng đá và cầu lông.',
                  accentColor: AppColors.secondary, // royal blue border left
                  tagBgColor: AppColors.secondary.withOpacity(0.1),
                  tagColor: AppColors.secondary,
                  icon: Icons.sports_basketball,
                  members: const [],
                  extraMembersCount: 80,
                ),
                const SizedBox(height: AppStyles.gutter),

                // Club 4
                _buildClubCard(
                  title: 'F-Speaker',
                  tag: 'Kỹ năng',
                  desc: 'Câu lạc bộ tranh biện và kỹ năng giao tiếp, giúp bạn tự tin hơn trước đám đông.',
                  accentColor: AppColors.primary, // orange border left
                  tagBgColor: AppColors.primaryFixed.withOpacity(0.5),
                  tagColor: AppColors.primary,
                  icon: Icons.record_voice_over,
                  members: const [
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAQsPAHTnlBJcStKNtKh6AqiJQoovmZJCO9DfRHiTZqIOrtSOERztvFkYwJ1uNtn76fPM5375kNnMBT5Xpmx36tm5SpXOevnTp73wgvJJmytS0o6csAVcMa-cxCSazD13xb19Q0eCs0s4S-9PUkvleFQlgyErKHcVEDd1MpSe6d5-aKKxJh7jyJJ9pDBaiiixC6D4HoWTPuFjCgO86gO67WpjzPVMKFA0cHRb4r_6CJ_pyTRj8l3QVP5Q1X3NwnFcYUiHb0Tw-1aEKN',
                  ],
                  extraMembersCount: 32,
                ),
              ],
            ),
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
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Đăng ký ngay',
                          style: AppStyles.labelLg.copyWith(
                            color: AppColors.primaryContainer,
                            fontWeight: FontWeight.bold,
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
                    // Members overlap avatars
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
                    // View Detail text button
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
