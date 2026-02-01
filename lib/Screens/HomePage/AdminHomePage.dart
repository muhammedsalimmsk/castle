import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Screens/HomePage/Widgets/StatusDetailWidget.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Colors/Colors.dart';
import '../../Controlls/DashboardController/AdminDashboardController.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardPage({super.key}) {
    controller.fetchDashboard(token!);
  }
  Future<void> _initOneSignalAndAskPermission(BuildContext context) async {
    // Initialize OneSignal

    // Ask for permission if not granted
    final status = await Permission.notification.status;

    if (!status.isGranted) {
      final result = await Permission.notification.request();

      if (result.isGranted) {
        await OneSignal.User.addTags({
          "role": userDetailModel!.data!.role,
        });
        await OneSignal.User.addEmail(userDetailModel!.data!.email ?? "");
        await OneSignal.User.addSms(userDetailModel!.data!.phone ?? "");
        await OneSignal.login(userDetailModel!.data!.id!);
        OneSignal.Notifications.requestPermission(true);
      } else if (result.isPermanentlyDenied) {
        _showOpenSettingsDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notifications denied ❌")),
        );
      }
    } else {
      // Already granted
    
      await OneSignal.User.addTags({
        "role": userDetailModel!.data!.role,
      });
      await OneSignal.User.addEmail(userDetailModel!.data!.email ?? "");
      await OneSignal.login(userDetailModel!.data!.id!);
      OneSignal.Notifications.requestPermission(true);
    }
  }

  void _showOpenSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Text(
          'Notifications are turned off. Please enable them in system settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(token);
    _initOneSignalAndAskPermission(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 170),
                  _buildTopCards(),
                  _priorityChartCard(),
                  _clientsHorizontalCard(),
                  _recentComplaintsCard(),
                  _activeWorkersCard(),
                ],
              ),
            ),
          ),
          Obx(() => Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: controller.loadingHeader.value
                    ? _buildHeaderLoading()
                    : TopWidgetOfAdminHome(
                        data: controller.dashStaticModel.value,
                      ),
              )),
        ],
      ),
    );
  }

  Widget _buildTopCards() {
    return Obx(() {
      if (controller.loadingTopCards.value) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: [
              Expanded(child: _buildCardSkeleton()),
              const SizedBox(width: 12),
              Expanded(child: _buildCardSkeleton()),
              const SizedBox(width: 12),
              Expanded(child: _buildCardSkeleton()),
            ],
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: _InfoCard(
                title: 'Complaints',
                value: controller.dashStaticModel.value.complaints?.total
                        ?.toString() ??
                    controller.totalComplaints.value.toString(),
                subtitle: 'Total open',
                icon: Icons.report_problem_rounded,
                onTap: () => Get.toNamed('/complaints'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCard(
                title: 'Clients',
                value: controller.dashStaticModel.value.users?.clients?.total
                        ?.toString() ??
                    controller.totalClients.value.toString(),
                subtitle: 'Active',
                icon: Icons.people_rounded,
                onTap: () => Get.toNamed('/clients'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCard(
                title: 'Equipment',
                value: controller.dashStaticModel.value.equipment?.total
                        ?.toString() ??
                    controller.totalEquipment.value.toString(),
                subtitle: 'Total',
                icon: Icons.precision_manufacturing_rounded,
                onTap: () => Get.toNamed('/equipment'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _priorityChartCard() {
    return Obx(() {
      if (controller.loadingPriorityChart.value) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: _buildCardSkeleton(height: 200),
        );
      }

      final priorityData =
          controller.dashStaticModel.value.complaintsByPriority;
      final urgentCount = priorityData?.urgent ?? controller.urgent.value;
      final mediumCount = priorityData?.medium ?? controller.medium.value;
      final highCount = priorityData?.high ?? controller.high.value;
      final lowCount = priorityData?.low ?? 0;

      final total = urgentCount + mediumCount + highCount + lowCount;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.toNamed('/complaints'),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dividerColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cardShadowColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: total == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      'No priority data available',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Complaints by Priority',
                                  style: TextStyle(
                                    color: containerColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  if (urgentCount > 0)
                                    PieChartSectionData(
                                      color: notWorkingTextColor,
                                      value: urgentCount.toDouble(),
                                      title: 'Urgent',
                                      radius: 45,
                                      titleStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: backgroundColor,
                                      ),
                                    ),
                                  if (mediumCount > 0)
                                    PieChartSectionData(
                                      color: buttonColor,
                                      value: mediumCount.toDouble(),
                                      title: 'Medium',
                                      radius: 45,
                                      titleStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: backgroundColor,
                                      ),
                                    ),
                                  if (highCount > 0)
                                    PieChartSectionData(
                                      color: workingTextColor,
                                      value: highCount.toDouble(),
                                      title: 'High',
                                      radius: 45,
                                      titleStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: backgroundColor,
                                      ),
                                    ),
                                  if (lowCount > 0)
                                    PieChartSectionData(
                                      color: Colors.green,
                                      value: lowCount.toDouble(),
                                      title: 'Low',
                                      radius: 45,
                                      titleStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: backgroundColor,
                                      ),
                                    ),
                                ],
                                sectionsSpace: 3,
                                centerSpaceRadius: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (urgentCount > 0)
                          _priorityLegend(
                              'Urgent', urgentCount, notWorkingTextColor),
                        if (urgentCount > 0) const SizedBox(height: 12),
                        if (mediumCount > 0)
                          _priorityLegend('Medium', mediumCount, buttonColor),
                        if (mediumCount > 0) const SizedBox(height: 12),
                        if (highCount > 0)
                          _priorityLegend('High', highCount, workingTextColor),
                        if (highCount > 0 && lowCount > 0)
                          const SizedBox(height: 12),
                        if (lowCount > 0)
                          _priorityLegend('Low', lowCount, Colors.green),
                      ],
                    )
                  ],
                ),
            ),
          ),
        ),
      );
    });
  }

  Widget _priorityLegend(String label, int value, Color dotColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: dotColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: dotColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: containerColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: TextStyle(
              color: dotColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentComplaintsCard() {
    return Obx(() {
      if (controller.loadingRecentComplaints.value) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: _buildCardSkeleton(height: 400),
        );
      }

      final complaints = controller.recentComplaints;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dividerColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Recent Complaints',
                        style: TextStyle(
                          color: containerColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/complaints'),
                    style: TextButton.styleFrom(
                      foregroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              complaints.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          'No recent complaints',
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 350,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: complaints.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: dividerColor,
                        ),
                        itemBuilder: (context, index) {
                          final r = complaints[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (r.id != null && r.id!.isNotEmpty) {
                                  Get.toNamed('/complaintDetails',
                                      arguments: {'complaintId': r.id!});
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    _priorityBadge(r.priority),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            r.title ?? '-',
                                            style: TextStyle(
                                              color: containerColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            r.description ?? '',
                                            style: TextStyle(
                                              color: subtitleColor,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (r.status == 'resolved'
                                                ? workingWidgetColor
                                                : buttonColor.withOpacity(0.1)),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            r.status ?? '',
                                            style: TextStyle(
                                              color: r.status == 'resolved'
                                                  ? workingTextColor
                                                  : buttonColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          DateFormat('dd MMM').format(
                                              r.reportedAt ?? DateTime.now()),
                                          style: TextStyle(
                                            color: subtitleColor,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      );
    });
  }

  Widget _priorityBadge(String? priority) {
    if (priority == null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: searchBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.info_outline_rounded, color: subtitleColor, size: 20),
      );
    }
    Color color = subtitleColor;
    IconData icon = Icons.label_outline_rounded;
    if (priority.toLowerCase() == 'urgent') {
      color = notWorkingTextColor;
      icon = Icons.priority_high_rounded;
    } else if (priority.toLowerCase() == 'medium') {
      color = buttonColor;
      icon = Icons.report_rounded;
    } else if (priority.toLowerCase() == 'high') {
      color = Colors.orange;
      icon = Icons.warning_amber_rounded;
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _clientsHorizontalCard() {
    return Obx(() {
      if (controller.loadingClients.value) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Clients",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCardSkeleton(width: 200),
                    const SizedBox(width: 12),
                    _buildCardSkeleton(width: 200),
                    const SizedBox(width: 12),
                    _buildCardSkeleton(width: 200),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      final clients = controller.clientStats;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.toNamed('/clients'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Clients",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            clients.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No clients available',
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        clients.length,
                        (index) {
                          final client = clients[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildClientCard(
                              name: client.clientName ?? "Unknown",
                              equipment: client.equipment?.total.toString() ??
                                  "No Equipment",
                              complaints:
                                  client.complaints?.total?.toString() ?? "0",
                              clientId: client.id!,
                            ),
                          );
                        },
                      ),
                    ),
                  )
          ],
        ),
      );
    });
  }

  Widget _activeWorkersCard() {
    return Obx(() {
      if (controller.loadingActiveWorkers.value) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Active Workers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: containerColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return _buildWorkerSkeleton();
                },
              ),
            ],
          ),
        );
      }

      final workers = controller.activeWorkers;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.toNamed('/workers'),
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      'Active Workers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: containerColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
                workers.isEmpty
                ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'No active workers data',
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.toNamed('/workers'),
                      borderRadius: BorderRadius.circular(12),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: workers.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final a = workers[index];
                          return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  buttonColor,
                                  buttonColor.withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: buttonColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${a.count ?? 0}',
                                style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            a.department ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: containerColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    },
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }

  // Loading skeleton widgets
  Widget _buildCardSkeleton({double? width, double? height}) {
    return Container(
      width: width,
      height: height ?? 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 16,
            decoration: BoxDecoration(
              color: dividerColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: width != null ? width * 0.6 : 80,
            height: 24,
            decoration: BoxDecoration(
              color: dividerColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: width != null ? width * 0.4 : 60,
            height: 14,
            decoration: BoxDecoration(
              color: dividerColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLoading() {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 16,
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerSkeleton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dividerColor.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 12,
          decoration: BoxDecoration(
            color: dividerColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

Widget _buildClientCard({
  required String name,
  required String equipment,
  required String complaints,
  required String clientId,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () =>
          Get.toNamed('/clientDetails', arguments: {'clientId': clientId}),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dividerColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cardShadowColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        buttonColor,
                        buttonColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    color: backgroundColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: containerColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.precision_manufacturing_rounded,
                    size: 16, color: subtitleColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    equipment,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.report_problem_rounded,
                    size: 16, color: subtitleColor),
                const SizedBox(width: 6),
                Text(
                  "$complaints Complaints",
                  style: TextStyle(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  const _InfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dividerColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: buttonColor, size: 22),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: containerColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
