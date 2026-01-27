import 'package:castle/Model/Admin%20Dashboard/dash_statics_model/data.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../Colors/Colors.dart';
import '../../../Model/Admin Dashboard/dash_statics_model/recent_complaint.dart';
import '../../../Model/dashboard_model/data.dart';
import 'SummaryCard.dart';

class TopWidgetOfAdminHome extends StatefulWidget {
  final DashStatic? data;
  const TopWidgetOfAdminHome({super.key, required this.data});

  @override
  State<TopWidgetOfAdminHome> createState() => _TopWidgetOfAdminHomeState();
}

class _TopWidgetOfAdminHomeState extends State<TopWidgetOfAdminHome>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = widget.data?.complaints?.total ?? 0;
    final runningTask = widget.data?.complaints?.inProgress ?? 0;
    final runningTaskPercent = totalTasks > 0
        ? double.parse((runningTask / totalTasks).toStringAsFixed(1))
        : 0.0;
    print(runningTaskPercent.toString());

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main container (top widget)
        Container(
            width: double.infinity,
            height: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Running Task",
                      style: TextStyle(
                          color: backgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$runningTask",
                      style: const TextStyle(
                          color: backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 20,
                        lineWidth: 4.0,
                        percent: runningTaskPercent,
                        center: Text(
                          runningTaskPercent.toString(),
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 12,
                          ),
                        ),
                        progressColor: buttonColor,
                        backgroundColor: shadeColor,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            totalTasks.toString(),
                            style: TextStyle(
                                color: backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Text(
                            "Tasks",
                            style: TextStyle(color: shadeColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),

        // Fold/unfold handle button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: _toggleExpand,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: backgroundColor,
                ),
              ),
            ),
          ),
        ),

        // Overlay unfold section
        AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          top: _isExpanded ? 0 : 0,
          left: 0,
          right: 0,
          height: _isExpanded
              ? MediaQuery.of(context).size.height * 0.8
              : 140, // folded height
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            color: _isExpanded ? Colors.white : containerColor,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _isExpanded
                  ? _buildFullDetails(context)
                  : _buildCollapsed(context, widget.data!),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCollapsed(BuildContext context, DashStatic data) {
    final totalTasks = data.complaints?.total ?? 0;
    final runningTask = data.complaints?.inProgress ?? 0;
    final runningTaskPercent = totalTasks > 0
        ? double.parse((runningTask / totalTasks).toStringAsFixed(1))
        : 0.0;

    return Container(
        width: double.infinity,
        height: 160,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Running Task",
                  style: TextStyle(
                      color: backgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "$runningTask",
                  style: const TextStyle(
                      color: backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 20,
                    lineWidth: 4.0,
                    percent: runningTaskPercent,
                    center: Text(
                      runningTaskPercent.toString(),
                      style: TextStyle(
                        color: backgroundColor,
                        fontSize: 12,
                      ),
                    ),
                    progressColor: buttonColor,
                    backgroundColor: shadeColor,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        totalTasks.toString(),
                        style: TextStyle(
                            color: backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        "Tasks",
                        style: TextStyle(color: shadeColor, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildFullDetails(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Scrollable content
            Positioned.fill(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.only(bottom: 70), // leave space for button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 12),
                    _buildBody(context),
                  ],
                ),
              ),
            ),

            // Close button at bottom center
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                    icon: Icon(
                      Icons.close_sharp,
                      color: backgroundColor,
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Overview',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Row(children: [
          _smallStat('Workers', widget.data!.users?.workers?.total ?? 0,
              'active ${widget.data!.users?.workers?.active ?? 0}'),
          const SizedBox(width: 8),
          _smallStat('Clients', widget.data!.users?.clients?.total ?? 0,
              'active ${widget.data!.users?.clients?.active ?? 0}'),
        ])
      ],
    );
  }

  Widget _smallStat(String label, int? value, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('$value',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
          Text(sub, style: TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // two column layout: left 60% (cards + priority), right 40% (recent complaints)
      final leftWidth = constraints.maxWidth;
      return SizedBox(
        width: leftWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _summaryGrid(),
              const SizedBox(height: 12),
              _priorityStrip(),
              const SizedBox(height: 12),
              _departmentBreakdown(),
            ],
          ),
        ),
      );
    });
  }

  Widget _summaryGrid() {
    final items = [
      SummaryCard(
          title: 'Total Complaints',
          value: (widget.data!.complaints?.total ?? 0).toString(),
          accent: buttonColor,
          icon: Icons.report_problem),
      SummaryCard(
          title: 'Open',
          value: (widget.data!.complaints?.open ?? 0).toString(),
          accent: Colors.orangeAccent,
          icon: Icons.report),
      SummaryCard(
          title: 'Resolved',
          value: (widget.data!.complaints?.resolved ?? 0).toString(),
          accent: Colors.greenAccent,
          icon: Icons.check_circle),
      SummaryCard(
          title: 'Inventory Low',
          value: (widget.data!.inventory?.lowStockParts ?? 0).toString(),
          accent: Colors.redAccent,
          icon: Icons.inventory_2),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 22) / 2; // spacing = 12
        const itemHeight = 100; // you can adjust this value
        final aspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) => items[i],
        );
      },
    );
  }

  Widget _priorityStrip() {
    final p = widget.data!.complaintsByPriority;

    final priorities = [
      {'label': 'Urgent', 'count': p?.urgent ?? 0, 'color': Colors.redAccent},
      {'label': 'High', 'count': p?.high ?? 0, 'color': Colors.orangeAccent},
      {
        'label': 'Medium',
        'count': p?.medium ?? 0,
        'color': Colors.yellowAccent
      },
      {'label': 'Low', 'count': p?.low ?? 0, 'color': Colors.greenAccent},
    ];

    final visiblePriorities =
        priorities.where((e) => (e['count'] as int? ?? 0) > 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'By Priority',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: visiblePriorities.isEmpty
              ? Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: visiblePriorities.map((e) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _priorityTile(
                          e['label'] as String,
                          e['count'] as int,
                          e['color'] as Color,
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _priorityTile(String label, int value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: color),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              '$label: $value',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _departmentBreakdown() {
    final byDept = widget.data!.complaints?.byDepartment ?? [];
    if (byDept.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('By Department',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: byDept
              .map((d) =>
                  _departmentRow(d.department ?? 'Unknown', d.count ?? 0))
              .toList(),
        ),
      )
    ]);
  }

  Widget _departmentRow(String name, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(name, style: TextStyle(color: Colors.white70))),
          Text('$count',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _recentComplaintsList() {
    final items = widget.data!.recentComplaints ?? [];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Recent Complaints',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12)),
          child: items.isEmpty
              ? Center(
                  child: Text('No recent complaints',
                      style: TextStyle(color: Colors.white38)))
              : ListView.separated(
                  itemBuilder: (context, i) {
                    final it = items[i];
                    return _complaintTile(it);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: items.length,
                ),
        ),
      )
    ]);
  }

  Widget _complaintTile(RecentComplaint it) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(it.title ?? 'Untitled',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700))),
          Text(it.priority ?? '',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
        ]),
        const SizedBox(height: 6),
        Text(it.description ?? '',
            style: TextStyle(color: Colors.white70, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(it.status ?? '',
              style: TextStyle(color: Colors.white38, fontSize: 12)),
          Text(it.reportedAt != null ? _formatDate(it.reportedAt!) : '',
              style: TextStyle(color: Colors.white38, fontSize: 12)),
        ])
      ]),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

// -------------------------
// Small reusable summary card
// -------------------------
