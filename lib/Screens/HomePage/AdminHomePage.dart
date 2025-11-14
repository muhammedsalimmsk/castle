import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Screens/HomePage/Widgets/StatusDetailWidget.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Colors/Colors.dart';
import '../../Controlls/DashboardController/AdminDashboardController.dart';
import 'package:get/get.dart';
import '../../Model/Admin Dashboard/dash_client_stat_model/datum.dart';
import 'Widgets/LinkinOverlay.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notifications already enabled ✅")),
      );
      await OneSignal.User.addTags({
        "role": userDetailModel!.data!.role,
      });
      await OneSignal.User.addEmail(userDetailModel!.data!.email ?? "");
      await OneSignal.User.addSms(userDetailModel!.data!.phone ?? "");
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
                child: TopWidgetOfAdminHome(
                  data: controller.dashStaticModel.value,
                ),
              )),
          // show LinkedIn-style skeleton overlay while loading
          Obx(() => controller.loading.value
              ? LinkedInLoadingOverlay()
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildTopCards() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoCard(
                title: 'Complaints',
                value: controller.totalComplaints.value.toString(),
                subtitle: 'Total open',
                icon: Icons.report_problem_outlined,
                width: 120,
              ),
              _InfoCard(
                title: 'Clients',
                value: controller.totalClients.value.toString(),
                subtitle: 'Active',
                icon: Icons.people_outline,
                width: 120,
              ),
              _InfoCard(
                title: 'Equipment',
                value: controller.totalEquipment.value.toString(),
                subtitle: 'Total',
                icon: Icons.build_outlined,
                width: 120,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _priorityChartCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Complaints by Priority',
                        style: TextStyle(
                            color: containerColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 140,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                                color: Colors.red,
                                value: controller.urgent.value.toDouble(),
                                title: 'Urgent'),
                            PieChartSectionData(
                                color: buttonColor,
                                value: controller.medium.value.toDouble(),
                                title: 'Medium'),
                            PieChartSectionData(
                                color: Colors.green,
                                value: controller.high.value.toDouble(),
                                title: 'High'),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _priorityLegend('Urgent', controller.urgent.value),
                  _priorityLegend('Medium', controller.medium.value),
                  _priorityLegend('High', controller.high.value),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityLegend(String label, int value) {
    Color dotColor;
    if (label == 'Urgent') {
      dotColor = Colors.red;
    } else if (label == 'Medium') {
      dotColor = buttonColor;
    } else {
      dotColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
              width: 12,
              height: 12,
              decoration:
                  BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          SizedBox(width: 8),
          Text(label, style: TextStyle(color: containerColor)),
          SizedBox(width: 8),
          Text('(${value.toString()})',
              style: TextStyle(color: containerColor.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _recentComplaintsCard() {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Complaints',
                    style: TextStyle(
                        color: containerColor, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: buttonColor),
                  child: Text('View All'),
                )
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 350,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: controller.recentComplaints.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final r = controller.recentComplaints[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: _priorityBadge(r.priority),
                    title: Text(r.title ?? '-',
                        style: TextStyle(
                            color: containerColor,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(r.description ?? '',
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(r.status ?? '',
                            style: TextStyle(
                                color: r.status == 'resolved'
                                    ? Colors.green
                                    : buttonColor)),
                        SizedBox(height: 6),
                        Text(
                            DateFormat('dd MMM')
                                .format(r.reportedAt ?? DateTime.now()),
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    onTap: () {},
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _priorityBadge(String? priority) {
    if (priority == null) {
      return CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.info_outline, color: containerColor));
    }
    Color color = Colors.grey;
    IconData icon = Icons.label;
    if (priority.toLowerCase() == 'urgent') {
      color = Colors.red;
      icon = Icons.priority_high;
    } else if (priority.toLowerCase() == 'medium') {
      color = Colors.orange;
      icon = Icons.report;
    } else if (priority.toLowerCase() == 'high') {
      color = Colors.purple;
      icon = Icons.warning_amber_outlined;
    }
    return CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, color: color));
  }

  Widget _clientsHorizontalCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clients",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                controller.clientStats.length,
                (index) {
                  final client = controller.clientStats[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 6.0),
                    child: _buildClientCard(
                        name: client.clientName ?? "Unknown",
                        equipment: client.equipment?.total.toString() ??
                            "No Equipment",
                        complaints: client.complaints?.total?.toString() ?? "0",
                        clientId: client.id!),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _clientCard(ClientStatModel c) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.clientName ?? '${c.firstName} ${c.lastName}',
                    style: TextStyle(
                        color: backgroundColor, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('${c.equipment?.total ?? 0} equipment',
                    style: TextStyle(color: backgroundColor.withOpacity(0.7))),
                SizedBox(height: 8),
                CircularPercentIndicator(
                  radius: 36.0,
                  lineWidth: 6.0,
                  percent: ((c.complaints?.completed ?? 0) /
                          ((c.complaints?.total ?? 1).toDouble()))
                      .clamp(0.0, 1.0),
                  center: Text(
                      '${c.complaints?.completed ?? 0}/${c.complaints?.total ?? 0}'),
                  progressColor: buttonColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeWorkersCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Workers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: containerColor,
            ),
          ),
          const SizedBox(height: 16),

          // Responsive Grid View
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.activeWorkers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Show 3 per row
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.75, // Square items
            ),
            itemBuilder: (context, index) {
              final a = controller.activeWorkers[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular bubble with gradient and shadow
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent.withOpacity(0.8),
                          buttonColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${a.count ?? 0}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    a.department ?? '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: containerColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildClientCard(
    {required String name,
    required String equipment,
    required String complaints,
    required String clientId}) {
  return InkWell(
    onTap: () {
      // Get.to();
    },
    child: Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: buttonColor),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.business, color: Colors.blue.shade700),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.build, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  equipment,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.folder, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "$complaints Complaints",
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final double width;
  final VoidCallbackAction? onTap;
  const _InfoCard(
      {required this.title,
      required this.value,
      required this.subtitle,
      required this.icon,
      required this.width,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          onTap;
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: buttonColor, width: 1),
              color: buttonColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: width,
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: buttonColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(icon, color: buttonColor, size: 18),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text(title,
                            style: TextStyle(
                                color: containerColor.withOpacity(0.9))))
                  ],
                ),
                SizedBox(height: 12),
                Text(value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: containerColor)),
                SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        color: containerColor.withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
