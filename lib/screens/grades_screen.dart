import 'package:flutter/material.dart';
import '../api/grade_api.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../widgets/custom_app_header.dart';
import '../api/auth_api.dart';
import 'grade_detail_screen.dart';
import '../api/enums.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final GradeApi _apiController = GradeApi();
  List<Grade> _grades = [];
  bool _isLoading = true;
  String? _errorMessage;

  GradeLevel _selectedClass = GradeLevel.khoi10;

  String _selectedSemester = 'Học kỳ 2 - Năm học 2023-2024';

  String getAcademicYearForClass(GradeLevel grade) {
    switch (grade) {
      case GradeLevel.khoi10:
        return '2023-2024';
      case GradeLevel.khoi11:
        return '2024-2025';
      case GradeLevel.khoi12:
        return '2025-2026';
    }
  }

  List<String> get _semestersForSelectedClass {
    final year = getAcademicYearForClass(_selectedClass);
    return SemesterTerm.values.map((term) => '${term.label} - Năm học $year').toList();
  }

  List<String> get _allSemesters {
    final List<String> list = [];
    for (var grade in GradeLevel.values) {
      final year = getAcademicYearForClass(grade);
      for (var term in SemesterTerm.values) {
        list.add('${term.label} - Năm học $year');
      }
    }
    return list;
  }

  List<SubjectType> get _allSubjects => SubjectType.values;

  @override
  void initState() {
    super.initState();
    _fetchGrades();
  }

  Future<void> _fetchGrades() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final studentId = AuthApi.currentUser?.studentId;
      final grades = await _apiController.getAllGrades(studentId: studentId);
      setState(() {
        _grades = grades;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  List<Grade> get _filteredGrades {
    if (_selectedSemester.startsWith('Cả năm')) {
      final parts = _selectedSemester.split(' - ');
      final yearPart = parts.length > 1 ? parts[1] : 'Năm học 2023-2024';
      final hk1SemName = 'Học kỳ 1 - $yearPart';
      final hk2SemName = 'Học kỳ 2 - $yearPart';

      final hk1Grades = _grades.where((g) => g.semester == hk1SemName).toList();
      final hk2Grades = _grades.where((g) => g.semester == hk2SemName).toList();

      final Map<String, Grade> hk1Map = {for (var g in hk1Grades) g.subjectCode.toUpperCase(): g};
      final Map<String, Grade> hk2Map = {for (var g in hk2Grades) g.subjectCode.toUpperCase(): g};

      final List<Grade> calculatedGrades = [];
      for (var sub in _allSubjects) {
        final code = sub.code;
        final name = sub.label;
        final g1 = hk1Map[code];
        final g2 = hk2Map[code];

        if (g1 != null && g1.assignmentScore != -1.0 && g1.overallScore != null &&
            g2 != null && g2.assignmentScore != -1.0 && g2.overallScore != null) {
          final overallHK1 = g1.overallScore!;
          final overallHK2 = g2.overallScore!;
          final overallCN = double.parse(((overallHK1 + 2.0 * overallHK2) / 3.0).toStringAsFixed(2));

          String letter = 'F';
          double gpa = 0.0;
          if (overallCN >= 9.0) { letter = 'A+'; gpa = 4.0; }
          else if (overallCN >= 8.5) { letter = 'A'; gpa = 3.7; }
          else if (overallCN >= 8.0) { letter = 'A-'; gpa = 3.5; }
          else if (overallCN >= 7.5) { letter = 'B+'; gpa = 3.2; }
          else if (overallCN >= 7.0) { letter = 'B'; gpa = 3.0; }
          else if (overallCN >= 6.5) { letter = 'B-'; gpa = 2.7; }
          else if (overallCN >= 6.0) { letter = 'C+'; gpa = 2.3; }
          else if (overallCN >= 5.5) { letter = 'C'; gpa = 2.0; }
          else if (overallCN >= 5.0) { letter = 'C-'; gpa = 1.7; }
          else if (overallCN >= 4.0) { letter = 'D'; gpa = 1.0; }

          calculatedGrades.add(Grade(
            gradeId: -999, // Dummy ID representing virtual Cả năm grade
            studentId: g1.studentId,
            studentName: g1.studentName,
            className: g1.className,
            subjectCode: code,
            subjectName: name,
            semester: _selectedSemester,
            assignmentScore: overallHK1, // Store HK1 overall score in assignmentScore slot for details page display
            midtermScore: overallHK2,    // Store HK2 overall score in midtermScore slot
            finalScore: -1.0,           // Not used for CN
            overallScore: overallCN,
            letterGrade: letter,
            gpaPoint: gpa,
            teacherComments: 'Điểm tổng kết cả năm tính tự động từ Điểm HK1 (${overallHK1.toStringAsFixed(2)}) và Điểm HK2 (${overallHK2.toStringAsFixed(2)}).',
          ));
        }
      }
      return calculatedGrades;
    }
    return _grades.where((g) => g.semester == _selectedSemester).toList();
  }

  List<Grade> get _completeSubjectGrades {
    final Map<String, Grade> actualGradesMap = {
      for (var g in _filteredGrades) g.subjectCode.toUpperCase(): g
    };

    final student = AuthApi.currentUser;
    final studentName = student?.fullName ?? 'Học sinh';
    final studentId = student?.studentId ?? 'HS001';
    final className = student?.className ?? '10A1';

    return _allSubjects.map((sub) {
      final code = sub.code;
      final name = sub.label;
      if (actualGradesMap.containsKey(code)) {
        return actualGradesMap[code]!;
      } else {
        return Grade(
          gradeId: null,
          studentId: studentId,
          studentName: studentName,
          className: className,
          subjectCode: code,
          subjectName: name,
          semester: _selectedSemester,
          assignmentScore: -1.0,
          midtermScore: -1.0,
          finalScore: -1.0,
          overallScore: null,
          letterGrade: null,
          gpaPoint: null,
          teacherComments: '',
        );
      }
    }).toList();
  }

  double get _dtbAverage {
    final list = _filteredGrades;
    if (list.isEmpty) return 0.0;
    double sum = list.fold(0.0, (prev, element) => prev + (element.overallScore ?? 0.0));
    return sum / list.length;
  }

  AcademicRank get _rankEnumNew {
    final list = _filteredGrades.where((g) => g.overallScore != null && g.overallScore != -1.0).toList();
    if (list.isEmpty) return AcademicRank.chuaDat;

    final scoreGrades = list.where((g) => !g.subjectType.isCommentEvaluation).toList();
    final commentGrades = list.where((g) => g.subjectType.isCommentEvaluation).toList();

    // Stats for score-based grades
    final allGe65 = scoreGrades.isNotEmpty && scoreGrades.every((g) => (g.overallScore ?? 0.0) >= 6.5);
    final allGe50 = scoreGrades.isNotEmpty && scoreGrades.every((g) => (g.overallScore ?? 0.0) >= 5.0);
    final countGe8 = scoreGrades.where((g) => (g.overallScore ?? 0.0) >= 8.0).length;
    final countGe65 = scoreGrades.where((g) => (g.overallScore ?? 0.0) >= 6.5).length;
    final countGe50 = scoreGrades.where((g) => (g.overallScore ?? 0.0) >= 5.0).length;
    final noUnder35 = scoreGrades.every((g) => (g.overallScore ?? 0.0) >= 3.5);

    // Stats for comment-based grades (Any score >= 5.0 is Đạt, < 5.0 is Chưa đạt)
    final countCommentChuaDat = commentGrades.where((g) => (g.overallScore ?? 0.0) < 5.0).length;

    // 1. Tốt: ĐTB các môn học đánh giá bằng điểm số >= 6.5, ít nhất 6 môn >= 8.0, và 100% môn nhận xét đạt mức Đạt (countCommentChuaDat == 0)
    if (allGe65 && countGe8 >= 6 && countCommentChuaDat == 0) {
      return AcademicRank.tot;
    }

    // 2. Khá: ĐTB các môn học đánh giá bằng điểm số >= 5.0, ít nhất 6 môn >= 6.5, và 100% môn nhận xét đạt mức Đạt (countCommentChuaDat == 0)
    if (allGe50 && countGe65 >= 6 && countCommentChuaDat == 0) {
      return AcademicRank.kha;
    }

    // 3. Đạt: Ít nhất 6 môn đánh giá bằng điểm số >= 5.0, không môn nào < 3.5, và tối đa 1 môn nhận xét Chưa đạt (countCommentChuaDat <= 1)
    if (countGe50 >= 6 && noUnder35 && countCommentChuaDat <= 1) {
      return AcademicRank.dat;
    }

    return AcademicRank.chuaDat;
  }

  String get _rankTextNew => _rankEnumNew.label;

  Color get _rankColorNew {
    switch (_rankEnumNew) {
      case AcademicRank.tot:
        return const Color(0xFF2E7D32); // Green
      case AcademicRank.kha:
        return const Color(0xFF1976D2); // Blue
      case AcademicRank.dat:
        return const Color(0xFFF57C00); // Orange
      case AcademicRank.chuaDat:
        return AppColors.error; // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppHeader(
        title: 'Điểm số',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _fetchGrades,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchGrades,
        color: AppColors.primary,
        child: _buildBodyContent(),
      ),
      floatingActionButton: AuthApi.currentUser?.role == 'admin'
          ? FloatingActionButton(
              heroTag: 'grades_screen_fab',
              onPressed: () => _showAddEditGradeDialog(),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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
                'Hãy đảm bảo Web App Java Tomcat đang hoạt động trên cổng 8080.\nLỗi: $_errorMessage',
                textAlign: TextAlign.center,
                style: AppStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchGrades,
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

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppStyles.containerPadding),
      children: [
        const SizedBox(height: AppStyles.stackLg),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Kết quả học tập',
                style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<GradeLevel>(
                  value: _selectedClass,
                  onChanged: (GradeLevel? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedClass = newValue;
                        final newSems = _semestersForSelectedClass;
                        // Select default Semester for the newly selected class
                        if (newSems.contains(_selectedSemester)) {
                          // keep it if possible
                        } else {
                          _selectedSemester = newSems[1]; // default to HK2
                        }
                      });
                    }
                  },
                  items: GradeLevel.values.map<DropdownMenuItem<GradeLevel>>((GradeLevel value) {
                    return DropdownMenuItem<GradeLevel>(
                      value: value,
                      child: Text(
                        value.classPrefix,
                        style: AppStyles.labelSm.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppStyles.stackSm),

        // Horizontal scrollable Semester list
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _semestersForSelectedClass.length,
            itemBuilder: (context, index) {
              final sem = _semestersForSelectedClass[index];
              final isSelected = sem == _selectedSemester;
              String displayName = sem.split(' - ')[0]; // E.g., "Học kỳ 1"
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(
                    displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : const Color(0xFFE8E8E8),
                      width: 1.2,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedSemester = sem;
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppStyles.stackLg),

        _buildBentoGrid(),

        const SizedBox(height: AppStyles.stackLg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DANH SÁCH MÔN HỌC',
              style: AppStyles.labelLg.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              '${_completeSubjectGrades.length} Môn học',
              style: AppStyles.labelSm.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: AppStyles.stackMd),

        ..._completeSubjectGrades.map((grade) => Padding(
              padding: const EdgeInsets.only(bottom: AppStyles.gutter),
              child: _buildGradeCard(grade),
            )),

        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildBentoGrid() {
    final dtb = _dtbAverage;
    final total = _filteredGrades.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 130,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Color(0x26000000), blurRadius: 6, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ĐTB Học Kỳ',
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
                      dtb == 0.0 ? '0.00' : dtb.toStringAsFixed(2),
                      style: AppStyles.display.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '/10.0',
                      style: AppStyles.labelSm.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 130,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _rankColorNew,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Color(0x13000000), blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Xếp Loại Học Lực',
                          style: AppStyles.labelSm.copyWith(color: Colors.white.withOpacity(0.9)),
                        ),
                        Text(
                          total == 0 ? 'N/A' : _rankTextNew,
                          style: AppStyles.labelLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 2)),
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
                              'Số Môn Học',
                              style: AppStyles.labelSm.copyWith(color: AppColors.onSurface),
                            ),
                            Text(
                              '$total Môn',
                              style: AppStyles.labelLg.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.menu_book, color: AppColors.primary, size: 22),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeCard(Grade grade) {
    final bool hasNoGrades = grade.assignmentScore == -1.0;
    Color accentColor = AppColors.secondary;
    String rankLabel = 'Chưa có';
    
    final isComment = grade.subjectType.isCommentEvaluation;
    
    if (hasNoGrades) {
      accentColor = Colors.grey.shade400;
      rankLabel = 'Chưa có';
    } else if (isComment) {
      final eval = SubjectEvaluation.fromScore(grade.overallScore);
      if (eval == SubjectEvaluation.dat) {
        accentColor = const Color(0xFF2E7D32); // Green
        rankLabel = 'Đạt (Đ)';
      } else {
        accentColor = AppColors.error; // Red
        rankLabel = 'Chưa đạt (KĐ)';
      }
    } else {
      final score = grade.overallScore ?? 0.0;
      if (score >= 8.5) {
        accentColor = const Color(0xFF2E7D32); // Green
        rankLabel = 'Tốt';
      } else if (score >= 6.5) {
        accentColor = const Color(0xFF1976D2); // Blue
        rankLabel = 'Khá';
      } else if (score >= 5.0) {
        accentColor = const Color(0xFFF57C00); // Orange
        rankLabel = 'Đạt';
      } else {
        accentColor = AppColors.error; // Red
        rankLabel = 'Chưa đạt';
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GradeDetailScreen(
              grade: grade,
              onUpdate: _fetchGrades,
            ),
          ),
        );
      },
      child: Container(
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
                              '${grade.studentName} (${grade.studentId}) • Lớp ${grade.className}',
                              style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              grade.subjectName,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          rankLabel,
                          style: AppStyles.labelLg.copyWith(
                            color: accentColor,
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
                  if (isComment)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Đánh giá nhận xét:',
                          style: AppStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        Text(
                          hasNoGrades ? 'Chưa đánh giá' : (grade.overallScore! >= 5.0 ? 'ĐẠT (Đ)' : 'CHƯA ĐẠT (KĐ)'),
                          style: AppStyles.headlineMd.copyWith(
                            color: hasNoGrades ? accentColor : (grade.overallScore! >= 5.0 ? const Color(0xFF2E7D32) : AppColors.error),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildScoreLabel('Bài tập (20%)', hasNoGrades ? '-' : grade.assignmentScore.toString()),
                        _buildScoreLabel('Giữa kỳ (30%)', hasNoGrades ? '-' : grade.midtermScore.toString()),
                        _buildScoreLabel('Cuối kỳ (50%)', hasNoGrades ? '-' : grade.finalScore.toString()),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Tổng kết',
                              style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasNoGrades ? '-' : (grade.overallScore?.toStringAsFixed(2) ?? '0.00'),
                              style: AppStyles.headlineMd.copyWith(
                                color: hasNoGrades ? accentColor : AppColors.primary,
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
      ),
    );
  }

  Widget _buildScoreLabel(String label, String score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10)),
        const SizedBox(height: 2),
        Text(score, style: AppStyles.labelLg.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showAddEditGradeDialog({Grade? grade}) {
    final isEdit = grade != null;
    
    final studentIdController = TextEditingController(text: grade?.studentId ?? 'HS001');
    final studentNameController = TextEditingController(text: grade?.studentName ?? 'Lê Văn A');
    final classNameController = TextEditingController(text: grade?.className ?? '10A1');
    final subjectCodeController = TextEditingController(text: grade?.subjectCode ?? 'PRO192');
    final subjectNameController = TextEditingController(text: grade?.subjectName ?? 'Object-Oriented Programming');
    final commentsController = TextEditingController(text: grade?.teacherComments ?? '');
    
    final assignmentController = TextEditingController(text: grade?.assignmentScore.toString() ?? '8.0');
    final midtermController = TextEditingController(text: grade?.midtermScore.toString() ?? '8.0');
    final finalController = TextEditingController(text: grade?.finalScore.toString() ?? '8.0');

    String localSemester = grade?.semester ?? _selectedSemester;
    
    final formKey = GlobalKey<FormState>();

    double liveOverall = 0.0;
    String liveLetter = 'F';
    double liveGpa = 0.0;

    void calculateLiveScores() {
      double ass = double.tryParse(assignmentController.text) ?? 0.0;
      double mid = double.tryParse(midtermController.text) ?? 0.0;
      double fin = double.tryParse(finalController.text) ?? 0.0;
      
      double overall = (ass + 2.0 * mid + 3.0 * fin) / 6.0;
      liveOverall = double.parse(overall.toStringAsFixed(2));

      if (liveOverall >= 9.0) { liveLetter = 'A+'; liveGpa = 4.0; }
      else if (liveOverall >= 8.5) { liveLetter = 'A'; liveGpa = 3.7; }
      else if (liveOverall >= 8.0) { liveLetter = 'A-'; liveGpa = 3.5; }
      else if (liveOverall >= 7.5) { liveLetter = 'B+'; liveGpa = 3.2; }
      else if (liveOverall >= 7.0) { liveLetter = 'B'; liveGpa = 3.0; }
      else if (liveOverall >= 6.5) { liveLetter = 'B-'; liveGpa = 2.7; }
      else if (liveOverall >= 6.0) { liveLetter = 'C+'; liveGpa = 2.3; }
      else if (liveOverall >= 5.5) { liveLetter = 'C'; liveGpa = 2.0; }
      else if (liveOverall >= 5.0) { liveLetter = 'C-'; liveGpa = 1.7; }
      else if (liveOverall >= 4.0) { liveLetter = 'D'; liveGpa = 1.0; }
      else { liveLetter = 'F'; liveGpa = 0.0; }
    }

    calculateLiveScores();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            
            void setupTextListener(TextEditingController controller) {
              controller.addListener(() {
                if (mounted) {
                  setDialogState(() {
                    calculateLiveScores();
                  });
                }
              });
            }

            setupTextListener(assignmentController);
            setupTextListener(midtermController);
            setupTextListener(finalController);

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(
                    isEdit ? Icons.edit_note : Icons.add_chart,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEdit ? 'Sửa Điểm Số' : 'Thêm Điểm Mới',
                    style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 12),
                        
                        Text('Thông tin học sinh', style: AppStyles.labelSm.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: studentIdController,
                                decoration: const InputDecoration(
                                  labelText: 'Mã HS',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => (val == null || val.isEmpty) ? 'Trống' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: studentNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Họ và tên',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => (val == null || val.isEmpty) ? 'Bắt buộc' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: classNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Lớp',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => (val == null || val.isEmpty) ? 'Trống' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Text('Môn học & Học kỳ', style: AppStyles.labelSm.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: subjectCodeController,
                                decoration: const InputDecoration(
                                  labelText: 'Mã môn',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => (val == null || val.isEmpty) ? 'Trống' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                controller: subjectNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Tên môn học',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => (val == null || val.isEmpty) ? 'Bắt buộc' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: localSemester,
                          decoration: const InputDecoration(
                            labelText: 'Học kỳ',
                            border: OutlineInputBorder(),
                          ),
                          items: _allSemesters.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                localSemester = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        Text('Điểm thành phần (Thang điểm 10)', style: AppStyles.labelSm.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: assignmentController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Chuyên cần (20%)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => _validateScore(val),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: midtermController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Giữa kỳ (30%)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => _validateScore(val),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: finalController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Cuối kỳ (50%)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => _validateScore(val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kết quả tính trực tiếp (Tự động)',
                                style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 11),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text('Tổng Kết', style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                                      Text(liveOverall.toStringAsFixed(2), style: AppStyles.labelLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Xếp loại', style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                                      Text(liveLetter, style: AppStyles.labelLg.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('GPA Scale', style: AppStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                                      Text(liveGpa.toStringAsFixed(2), style: AppStyles.labelLg.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: commentsController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Nhận xét của giáo viên',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy', style: TextStyle(color: AppColors.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      
                      final newGrade = Grade(
                        gradeId: grade?.gradeId,
                        studentId: studentIdController.text,
                        studentName: studentNameController.text,
                        className: classNameController.text,
                        subjectCode: subjectCodeController.text,
                        subjectName: subjectNameController.text,
                        semester: localSemester,
                        assignmentScore: double.parse(assignmentController.text),
                        midtermScore: double.parse(midtermController.text),
                        finalScore: double.parse(finalController.text),
                        teacherComments: commentsController.text,
                      );

                      setState(() {
                        _isLoading = true;
                      });

                      bool success;
                      if (isEdit) {
                        success = await _apiController.updateGrade(newGrade);
                      } else {
                        success = await _apiController.createGrade(newGrade);
                      }

                      if (success) {
                        _showSnackBar(isEdit ? 'Cập nhật điểm thành công!' : 'Thêm điểm mới thành công!');
                      } else {
                        _showSnackBar('Lỗi thao tác cơ sở dữ liệu!');
                      }

                      _fetchGrades();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer),
                  child: Text(isEdit ? 'Lưu' : 'Thêm', style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? _validateScore(String? val) {
    if (val == null || val.isEmpty) return 'Bắt buộc';
    final parsed = double.tryParse(val);
    if (parsed == null) return 'Sai định dạng';
    if (parsed < 0 || parsed > 10) return '0 - 10';
    return null;
  }



  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyles.labelSm.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.onSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
