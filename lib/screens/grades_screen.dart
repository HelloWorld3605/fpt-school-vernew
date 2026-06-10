import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  String _selectedSemester = 'Học kỳ 2 - Năm học 2023-2024';
  final List<String> _semesters = [
    'Học kỳ 1 - Năm học 2023-2024',
    'Học kỳ 2 - Năm học 2023-2024',
    'Học kỳ hè - Năm học 2023-2024',
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
                      border: Border.all(color: AppColors.primary, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuC7tfV5e-q2yfuPQpwzEfp5WppIWDP3ZES2NbOfVpUTELnfUpPY8Kz117ASzpFgE3VD0AjcmcmzcsJYGY4TEyWoxnVhZ_TdLEscOhFZ-RsI71B7nzVYeEnza_JQllxlEzrJzBT-QfkSzJyjhCF_SuBlnTzKWboi3J5Jq_Qnfn_b5JpuXJ4N6nt7TlbdKZMzRC3xF3wy7nKK37ElEIeexGaZt5G3hyogmHSDSOYMxhg6fReMgYH4rsQyAHK0jOP3snGYmzYKogegS-1V',
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
            
            // Title & Semester Dropdown
            Text(
              'Kết quả học tập',
              style: AppStyles.headlineLg.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSemester,
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more, color: AppColors.primaryContainer),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSemester = newValue;
                      });
                    }
                  },
                  items: _semesters.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppStyles.labelLg.copyWith(color: AppColors.onSurface),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: AppStyles.stackLg),

            // GPA Summary Bento Layout (Grid)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GPA Card (Left side)
                Expanded(
                  child: Container(
                    height: 140,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer, // orange background
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'GPA Tổng kết',
                          style: AppStyles.labelSm.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '8.4',
                              style: AppStyles.display.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '/10',
                              style: AppStyles.labelLg.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Rank & Credits (Right side)
                Expanded(
                  child: SizedBox(
                    height: 140,
                    child: Column(
                      children: [
                        // Rank card
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer, // blue background
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x13000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Xếp loại',
                                  style: AppStyles.labelSm.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Giỏi',
                                  style: AppStyles.headlineMd.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Credits card
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHighest, // light grey-blue
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Số tín chỉ',
                                      style: AppStyles.labelSm.copyWith(color: AppColors.onSurface),
                                    ),
                                    Text(
                                      '18/18',
                                      style: AppStyles.headlineMd.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.workspace_premium,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.stackLg),

            // Grades List Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách môn học'.toUpperCase(),
                  style: AppStyles.labelLg.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  'Chi tiết',
                  style: AppStyles.labelSm.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.stackMd),

            // Subject 1
            _buildGradeCard(
              code: 'PRO192',
              subject: 'Object-Oriented Programming',
              credits: '3 Tín chỉ',
              accentColor: AppColors.tertiary,
              midScore: '8.5',
              finalScore: '7.8',
              avgScore: '8.1',
              isPending: false,
            ),
            const SizedBox(height: AppStyles.gutter),

            // Subject 2
            _buildGradeCard(
              code: 'MAD101',
              subject: 'Discrete Mathematics',
              credits: '3 Tín chỉ',
              accentColor: AppColors.primary,
              midScore: '9.0',
              finalScore: '8.2',
              avgScore: '8.5',
              isPending: false,
            ),
            const SizedBox(height: AppStyles.gutter),

            // Subject 3
            _buildGradeCard(
              code: 'OSG202',
              subject: 'Operating Systems',
              credits: '3 Tín chỉ',
              accentColor: AppColors.secondary,
              midScore: '7.5',
              finalScore: '8.8',
              avgScore: '8.3',
              isPending: false,
            ),
            const SizedBox(height: AppStyles.gutter),

            // Subject 4 - Pending
            _buildGradeCard(
              code: 'NWC203c',
              subject: 'Computer Networking',
              credits: '3 Tín chỉ',
              accentColor: AppColors.outline,
              midScore: '-',
              finalScore: '-',
              avgScore: '-',
              isPending: true,
            ),
            const SizedBox(height: 120), // Spacer for bottom navigation
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xffFFA726), Color(0xffFF7043)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffFF9800).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.contact_support_outlined, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildGradeCard({
    required String code,
    required String subject,
    required String credits,
    required Color accentColor,
    required String midScore,
    required String finalScore,
    required String avgScore,
    required bool isPending,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            code,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPending 
                            ? AppColors.surfaceContainerHigh 
                            : accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        credits,
                        style: AppStyles.labelSm.copyWith(
                          color: isPending ? AppColors.onSurface : accentColor,
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
                if (isPending)
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Đang cập nhật điểm...',
                      style: AppStyles.labelLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giữa kỳ',
                            style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            midScore,
                            style: AppStyles.labelLg.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cuối kỳ',
                            style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            finalScore,
                            style: AppStyles.labelLg.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Trung bình',
                            style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            avgScore,
                            style: AppStyles.headlineMd.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
