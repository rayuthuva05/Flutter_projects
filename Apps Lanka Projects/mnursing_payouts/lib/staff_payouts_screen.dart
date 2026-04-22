import 'package:flutter/material.dart';
import 'package:mnursing_payouts/api/api.dart';

class StaffPayoutsScreen extends StatelessWidget {
  const StaffPayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Payouts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF008081),
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDE3EC), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDE3EC), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF008081), width: 1.5),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF6B7A99),
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF008081),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          prefixIconColor: const Color(0xFF6B7A99),
        ),
      ),
      home: const StaffPayoutsPage(),
    );
  }
}

class StaffPayoutsPage extends StatefulWidget {
  const StaffPayoutsPage({super.key});

  @override
  State<StaffPayoutsPage> createState() => _StaffPayoutsPageState();
}

class _StaffPayoutsPageState extends State<StaffPayoutsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _isloading;
  List payouts = [];

  void fetchData() async {
    final data = await FetchService.fetchPayouts();
    setState(() {
      payouts = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _isloading = true;

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isloading = false;
      });
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: _isloading
            ? ShimmerScreen()
            : Column(
                children: [
                  _buildSummaryCards(),
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [_buildTasksTab(), _buildPayoutsTab()],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     height: 120,
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Color(0xFF0F766E), Color(0xFF0EA5A4)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(30),
  //         bottomRight: Radius.circular(30),
  //       ),
  //     ),
  //     padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           icon: const Icon(Icons.arrow_back, color: Colors.white),
  //         ),
  //         const SizedBox(width: 10),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Text(
  //               "Staff Payouts",
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 28,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             Text(
  //               payouts.isNotEmpty
  //                   ? "User ID: ${payouts[0]['user_id']}"
  //                   : "Loading...",
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const Spacer(),
  //         const Icon(Icons.person, color: Colors.white, size: 88),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSummaryCards() {
    if (payouts.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _SummaryCard(
            label: 'Total Orders',
            count: payouts[0]['orders_count'],
            icon: Icons.assignment_turned_in,
          ),
          const SizedBox(width: 12),
          _SummaryCard(
            label: 'Total Earned',
            amount: double.tryParse(payouts[0]['amount'].toString()) ?? 0,
            icon: Icons.account_balance_wallet,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0F766E),
          labelColor: const Color(0xFF0F766E),
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "All Orders"),
            Tab(text: "Payouts"),
          ],
        ),
      ],
    );
  }

  Widget _buildTasksTab() {
    if (payouts.isEmpty) {
      return Center(
        child: Text(
          "No Orders avaliable",
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      );
    }
    return _buildOrdersList(orders: payouts);
  }

  Widget _buildPayoutsTab() {
    final fulfilledPayouts = payouts
        .where((p) => p['status'] == 'fulfilled')
        .toList();
    if (fulfilledPayouts.isEmpty) {
      return Center(
        child: Text(
          "No payouts avaliable",
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      );
    }
    return _buildOrdersList(orders: fulfilledPayouts);
  }

  Widget _buildOrdersList({required List orders}) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade100, Colors.teal.shade50],
                  ),
                ),
                child: const Icon(
                  Icons.assignment_turned_in,
                  color: Color(0xFF0F766E),
                ),
              ),

              title: Row(
                children: [
                  Text(
                    'Reference No: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F766E),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    order['reference_no'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F766E),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              subtitle: Row(
                children: [
                  Text(
                    'Status: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F766E),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    order['status'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F766E),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_down),
              children: [
                _detailRow(
                  "Booking Reference",
                  order['reference_no'].toString(),
                ),
                _detailRow("Status", order['status']),

                if (order.containsKey('amount'))
                  _detailRow("Amount", "Rs ${order['amount']}"),

                if (order.containsKey('user_id'))
                  _detailRow("User ID", order['user_id'].toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F766E),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double? amount;
  final int? count;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    this.amount,
    this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [Colors.white, Colors.teal.shade50]),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0F766E), size: 30),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  count != null ? "$count" : "Rs ${amount!.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F766E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerScreen extends StatefulWidget {
  const ShimmerScreen({super.key});

  @override
  State<ShimmerScreen> createState() => _LoaderSceenState();
}

class _LoaderSceenState extends State<ShimmerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final _shimmerGradient = LinearGradient(
    colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dx = _controller.value * 2 - 1;

        return ShaderMask(
          shaderCallback: (bounds) {
            return _shimmerGradient.createShader(
              Rect.fromLTWH(dx * bounds.width, 0, bounds.width, bounds.height),
            );
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: _buildContent(),
    );
  }

  Widget loaderContainer() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _shimmerGradient,
      ),
    );
  }

  Widget loadButton() {
    return Container(
      width: 120,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: _shimmerGradient,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF0EA5A4)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              loaderCircle(40),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(width: 120, height: 16),
                  const SizedBox(height: 6),
                  shimmerBox(width: 80, height: 14),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: shimmerCard()),
              const SizedBox(width: 12),
              Expanded(child: shimmerCard()),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            shimmerBox(width: 100, height: 16),
            shimmerBox(width: 100, height: 16),
          ],
        ),

        const SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    loaderCircle(50),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerBox(width: 150, height: 16),
                          const SizedBox(height: 8),
                          shimmerBox(width: 100, height: 14),
                          const SizedBox(height: 8),
                          shimmerBox(width: 80, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget shimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget shimmerCard() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
    );
  }

  Widget loaderCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}
