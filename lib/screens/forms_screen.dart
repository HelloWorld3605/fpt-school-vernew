import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../api/form_api.dart';
import '../api/auth_api.dart';
import '../widgets/custom_app_header.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final FormApi _apiController = FormApi();
  List<FormRequestModel> _requests = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final studentId = AuthApi.currentUser?.studentId ?? 'HS001';
      final list = await _apiController.getRequests(studentId);
      setState(() {
        _requests = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  void _showAddRequestDialog() {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    
    String selectedDept = 'Phòng Đào tạo';
    final departments = ['Phòng Đào tạo', 'Phòng Công tác SV', 'Ban Quản lý CSVC', 'Phòng Kế toán'];

    String selectedCategory = 'Học thuật';
    final categories = ['Học thuật', 'Hành chính', 'Tài chính', 'Cơ sở vật chất'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffFFA726), Color(0xffFF7043)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.note_add_rounded, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Tạo yêu cầu đơn từ',
                      style: AppStyles.headlineMd.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Tiêu đề đơn *',
                        style: AppStyles.labelLg.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: 'VD: Đơn xin nghỉ học tạm thời',
                          prefixIcon: const Icon(Icons.edit_note, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Vui lòng nhập tiêu đề đơn';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Danh mục đơn từ *',
                        style: AppStyles.labelLg.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.category_outlined, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                          ),
                        ),
                        items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedCategory = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Phòng ban xử lý *',
                        style: AppStyles.labelLg.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: selectedDept,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.business_outlined, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                          ),
                        ),
                        items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedDept = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.outline),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text(
                    'Hủy bỏ',
                    style: AppStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    final title = titleController.text.trim();
                    
                    Navigator.pop(context);

                    setState(() {
                      _isLoading = true;
                    });

                    final code = '#RQ-${(1000 + (title.hashCode % 9000)).abs()}';
                    final studentId = AuthApi.currentUser?.studentId ?? 'HS001';
                    
                    final newRequest = FormRequestModel(
                      studentId: studentId,
                      title: title,
                      code: code,
                      status: 'Đang xử lý',
                      requestDate: 'Hôm nay',
                      department: selectedDept,
                      category: selectedCategory,
                    );

                    final success = await _apiController.createRequest(newRequest);
                    if (success) {
                      _showSnackBar('Gửi yêu cầu đơn từ thành công!');
                    } else {
                      _showSnackBar('Gửi yêu cầu thất bại.');
                    }
                    _fetchRequests();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Gửi yêu cầu'),
                ),
              ],
            );
          },
        );
      },
    );
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
        title: 'Đơn từ',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _fetchRequests,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRequests,
        color: AppColors.primary,
        child: _buildBodyContent(),
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
          heroTag: 'forms_fab',
          onPressed: _showAddRequestDialog,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
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

          // Active Requests
          Text(
            'Đơn đã gửi',
            style: AppStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
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
                    ElevatedButton(onPressed: _fetchRequests, child: const Text('Thử lại')),
                  ],
                ),
              ),
            )
          else if (_requests.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  const Icon(Icons.inbox, size: 48, color: AppColors.outline),
                  const SizedBox(height: 12),
                  Text(
                    'Bạn chưa gửi đơn từ nào',
                    style: AppStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            )
          else
            ..._requests.map((r) {
              Color statusColor = AppColors.onSurfaceVariant;
              Color statusBg = AppColors.surfaceContainerHigh;
              Color leftBorder = AppColors.primary;

              if (r.status == 'Đang xử lý') {
                statusColor = Colors.yellow.shade800;
                statusBg = Colors.yellow.shade100;
                leftBorder = Colors.blue.shade500;
              } else if (r.status == 'Đã phê duyệt') {
                statusColor = Colors.green.shade800;
                statusBg = Colors.green.shade100;
                leftBorder = Colors.green.shade500;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppStyles.gutter),
                child: _buildRequestCard(
                  title: r.title,
                  code: r.code,
                  status: r.status,
                  statusColor: statusColor,
                  statusBg: statusBg,
                  leftBorderColor: leftBorder,
                  date: r.requestDate,
                  department: r.department,
                ),
              );
            }),
          const SizedBox(height: 120),
        ],
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
