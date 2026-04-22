import 'package:flutter/material.dart';

enum TaskStatus { pending, inProgress, fulfilled, cancelled }

enum PayoutStatus { unpaid, processing, paid }

class StaffTask {
  final String id;
  final String bookingId;
  final String bookingReference;
  final String clientName;
  final String serviceType;
  final DateTime scheduledDate;
  final String location;
  final TaskStatus taskStatus;
  final PayoutStatus payoutStatus;
  final double payoutAmount;
  final DateTime? paidDate;

  const StaffTask({
    required this.id,
    required this.bookingId,
    required this.bookingReference,
    required this.clientName,
    required this.serviceType,
    required this.scheduledDate,
    required this.location,
    required this.taskStatus,
    required this.payoutStatus,
    required this.payoutAmount,
    this.paidDate,
  });
}

// ─────────────────────────────────────────────
//  Mock Data
// ─────────────────────────────────────────────

final List<StaffTask> _mockTasks = [
  StaffTask(
    id: 't1',
    bookingId: 'b1001',
    bookingReference: 'BK-2024-1001',
    clientName: 'Samantha Perera',
    serviceType: 'Deep House Cleaning',
    scheduledDate: DateTime(2024, 6, 5, 9, 0),
    location: '12 Galle Rd, Colombo 03',
    taskStatus: TaskStatus.fulfilled,
    payoutStatus: PayoutStatus.paid,
    payoutAmount: 3500.00,
    paidDate: DateTime(2024, 6, 7),
  ),
  StaffTask(
    id: 't2',
    bookingId: 'b1002',
    bookingReference: 'BK-2024-1002',
    clientName: 'Rohan Fernando',
    serviceType: 'AC Maintenance',
    scheduledDate: DateTime(2024, 6, 8, 14, 0),
    location: '45 Duplication Rd, Colombo 04',
    taskStatus: TaskStatus.fulfilled,
    payoutStatus: PayoutStatus.processing,
    payoutAmount: 2800.00,
  ),
  StaffTask(
    id: 't3',
    bookingId: 'b1003',
    bookingReference: 'BK-2024-1003',
    clientName: 'Priya Jayawardena',
    serviceType: 'Plumbing Repair',
    scheduledDate: DateTime(2024, 6, 12, 10, 30),
    location: '8 Flower Rd, Colombo 07',
    taskStatus: TaskStatus.inProgress,
    payoutStatus: PayoutStatus.unpaid,
    payoutAmount: 1800.00,
  ),
  StaffTask(
    id: 't4',
    bookingId: 'b1004',
    bookingReference: 'BK-2024-1004',
    clientName: 'Kasun Silva',
    serviceType: 'Electrical Works',
    scheduledDate: DateTime(2024, 6, 15, 8, 0),
    location: '33 Bauddhaloka Mawatha, Colombo 07',
    taskStatus: TaskStatus.pending,
    payoutStatus: PayoutStatus.unpaid,
    payoutAmount: 4200.00,
  ),
  StaffTask(
    id: 't5',
    bookingId: 'b1005',
    bookingReference: 'BK-2024-1005',
    clientName: 'Dilani Wickramasinghe',
    serviceType: 'Garden Maintenance',
    scheduledDate: DateTime(2024, 5, 28, 7, 30),
    location: '91 Rosmead Place, Colombo 07',
    taskStatus: TaskStatus.fulfilled,
    payoutStatus: PayoutStatus.paid,
    payoutAmount: 2200.00,
    paidDate: DateTime(2024, 5, 30),
  ),
  StaffTask(
    id: 't6',
    bookingId: 'b1006',
    bookingReference: 'BK-2024-1006',
    clientName: 'Nuwan Rajapaksa',
    serviceType: 'Pest Control',
    scheduledDate: DateTime(2024, 6, 3, 11, 0),
    location: '17 Thurstan Rd, Colombo 03',
    taskStatus: TaskStatus.cancelled,
    payoutStatus: PayoutStatus.unpaid,
    payoutAmount: 0.00,
  ),
];

// ─────────────────────────────────────────────
//  Entry Point
// ─────────────────────────────────────────────

void main() {
  runApp(const PayoutsApp());
}

class PayoutsApp extends StatelessWidget {
  const PayoutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Payouts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Helvetica Neue',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A2540),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      home: const StaffPayoutsPage(),
    );
  }
}

// ─────────────────────────────────────────────
//  Main Page
// ─────────────────────────────────────────────

class StaffPayoutsPage extends StatefulWidget {
  const StaffPayoutsPage({super.key});

  @override
  State<StaffPayoutsPage> createState() => _StaffPayoutsPageState();
}

class _StaffPayoutsPageState extends State<StaffPayoutsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0; // 0=All, 1=Fulfilled, 2=Pending, 3=In Progress

  final List<String> _filters = ['All', 'Fulfilled', 'Pending', 'In Progress'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<StaffTask> get _filteredTasks {
    switch (_selectedFilter) {
      case 1:
        return _mockTasks
            .where((t) => t.taskStatus == TaskStatus.fulfilled)
            .toList();
      case 2:
        return _mockTasks
            .where((t) => t.taskStatus == TaskStatus.pending)
            .toList();
      case 3:
        return _mockTasks
            .where((t) => t.taskStatus == TaskStatus.inProgress)
            .toList();
      default:
        return _mockTasks;
    }
  }

  List<StaffTask> get _payoutTasks => _mockTasks
      .where((t) => t.taskStatus == TaskStatus.fulfilled)
      .toList();

  double get _totalEarned => _mockTasks
      .where((t) => t.payoutStatus == PayoutStatus.paid)
      .fold(0, (sum, t) => sum + t.payoutAmount);

  double get _pendingPayout => _mockTasks
      .where((t) =>
          t.taskStatus == TaskStatus.fulfilled &&
          t.payoutStatus != PayoutStatus.paid)
      .fold(0, (sum, t) => sum + t.payoutAmount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSummaryCards(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTasksTab(),
                  _buildPayoutsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFF0A2540),
            child: Text(
              'AP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Amal Perera',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0A2540),
                ),
              ),
              Text(
                'Staff ID: STF-0042',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: const Color(0xFF0A2540),
          ),
        ],
      ),
    );
  }

  // ── Summary Cards ────────────────────────────

  Widget _buildSummaryCards() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        children: [
          _SummaryCard(
            label: 'Total Earned',
            amount: _totalEarned,
            icon: Icons.account_balance_wallet_rounded,
            color: const Color(0xFF00875A),
            bgColor: const Color(0xFFE3F9EE),
          ),
          const SizedBox(width: 10),
          _SummaryCard(
            label: 'Pending',
            amount: _pendingPayout,
            icon: Icons.schedule_rounded,
            color: const Color(0xFFF59E0B),
            bgColor: const Color(0xFFFEF3C7),
          ),
          const SizedBox(width: 10),
          _SummaryCard(
            label: 'Total Tasks',
            amount: null,
            count: _mockTasks.length,
            icon: Icons.task_alt_rounded,
            color: const Color(0xFF0A2540),
            bgColor: const Color(0xFFEEF2FF),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ──────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF0A2540),
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: const Color(0xFF0A2540),
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'My Tasks'),
              Tab(text: 'Payouts'),
            ],
          ),
        ],
      ),
    );
  }

  // ── Tasks Tab ────────────────────────────────

  Widget _buildTasksTab() {
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: _filteredTasks.isEmpty
              ? _buildEmptyState('No tasks found')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: _filteredTasks.length,
                  itemBuilder: (context, index) {
                    return _TaskCard(task: _filteredTasks[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: const Color(0xFFF7F8FA),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_filters.length, (i) {
            final selected = _selectedFilter == i;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF0A2540) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF0A2540)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    _filters[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Payouts Tab ──────────────────────────────

  Widget _buildPayoutsTab() {
    return _payoutTasks.isEmpty
        ? _buildEmptyState('No payouts available')
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: _payoutTasks.length,
            itemBuilder: (context, index) {
              return _PayoutCard(task: _payoutTasks[index]);
            },
          );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Summary Card Widget
// ─────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final double? amount;
  final int? count;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _SummaryCard({
    required this.label,
    required this.amount,
    this.count,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              count != null
                  ? '$count'
                  : 'Rs ${amount!.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: count != null ? 22 : 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color.withOpacity(0.75),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Task Card Widget
// ─────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final StaffTask task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ServiceIcon(serviceType: task.serviceType),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.serviceType,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0A2540),
                              ),
                            ),
                          ),
                          _TaskStatusBadge(status: task.taskStatus),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.bookingReference,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Client',
                  value: task.clientName,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: _formatDate(task.scheduledDate),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: task.location,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payout Amount',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          task.taskStatus == TaskStatus.cancelled
                              ? '—'
                              : 'Rs ${task.payoutAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0A2540),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _PayoutStatusPill(
                          status: task.payoutStatus,
                          isCancelled:
                              task.taskStatus == TaskStatus.cancelled,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour < 12 ? 'AM' : 'PM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  •  $h:$m $amPm';
  }
}

// ─────────────────────────────────────────────
//  Payout Card Widget
// ─────────────────────────────────────────────

class _PayoutCard extends StatelessWidget {
  final StaffTask task;

  const _PayoutCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final isPaid = task.payoutStatus == PayoutStatus.paid;
    final isProcessing = task.payoutStatus == PayoutStatus.processing;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPaid
              ? const Color(0xFF00875A).withOpacity(0.2)
              : isProcessing
                  ? const Color(0xFFF59E0B).withOpacity(0.3)
                  : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.bookingReference,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0A2540),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        task.serviceType,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                _PayoutStatusPill(status: task.payoutStatus, isCancelled: false),
              ],
            ),

            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.grey.shade100),
            const SizedBox(height: 14),

            // Client & paid date
            Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 6),
                Text(
                  task.clientName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (isPaid && task.paidDate != null) ...[
                  const Icon(Icons.check_circle_rounded,
                      size: 14, color: Color(0xFF00875A)),
                  const SizedBox(width: 4),
                  Text(
                    'Paid ${_formatShortDate(task.paidDate!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00875A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (isProcessing)
                  Text(
                    'Processing…',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFF59E0B).withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Amount row
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isPaid
                    ? const Color(0xFFE3F9EE)
                    : isProcessing
                        ? const Color(0xFFFEF3C7)
                        : const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    'Payout',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Rs ${task.payoutAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isPaid
                          ? const Color(0xFF00875A)
                          : isProcessing
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF0A2540),
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

  String _formatShortDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

// ─────────────────────────────────────────────
//  Helper Widgets
// ─────────────────────────────────────────────

class _ServiceIcon extends StatelessWidget {
  final String serviceType;

  const _ServiceIcon({required this.serviceType});

  IconData get _icon {
    final s = serviceType.toLowerCase();
    if (s.contains('clean')) return Icons.cleaning_services_rounded;
    if (s.contains('plumb')) return Icons.plumbing_rounded;
    if (s.contains('electric')) return Icons.electrical_services_rounded;
    if (s.contains('ac') || s.contains('air')) return Icons.ac_unit_rounded;
    if (s.contains('garden') || s.contains('pest')) return Icons.grass_rounded;
    return Icons.handyman_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_icon, size: 22, color: const Color(0xFF0A2540)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskStatusBadge extends StatelessWidget {
  final TaskStatus status;

  const _TaskStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case TaskStatus.fulfilled:
        bg = const Color(0xFFE3F9EE);
        fg = const Color(0xFF00875A);
        label = 'Fulfilled';
        icon = Icons.check_circle_rounded;
        break;
      case TaskStatus.inProgress:
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        label = 'In Progress';
        icon = Icons.timelapse_rounded;
        break;
      case TaskStatus.pending:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        label = 'Pending';
        icon = Icons.schedule_rounded;
        break;
      case TaskStatus.cancelled:
        bg = const Color(0xFFFFF1F2);
        fg = const Color(0xFFBE123C);
        label = 'Cancelled';
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutStatusPill extends StatelessWidget {
  final PayoutStatus status;
  final bool isCancelled;

  const _PayoutStatusPill({required this.status, required this.isCancelled});

  @override
  Widget build(BuildContext context) {
    if (isCancelled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'N/A',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    Color bg;
    Color fg;
    String label;

    switch (status) {
      case PayoutStatus.paid:
        bg = const Color(0xFFE3F9EE);
        fg = const Color(0xFF00875A);
        label = 'Paid';
        break;
      case PayoutStatus.processing:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        label = 'Processing';
        break;
      case PayoutStatus.unpaid:
        bg = const Color(0xFFF3F4F6);
        fg = Colors.grey.shade500;
        label = 'Unpaid';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}