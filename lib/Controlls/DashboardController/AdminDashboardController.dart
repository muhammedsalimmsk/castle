import 'dart:convert';

import 'package:castle/Model/Admin%20Dashboard/dash_statics_model/data.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';

import '../../Model/Admin Dashboard/active_woker_count/active_woker_count.dart';
import '../../Model/Admin Dashboard/active_woker_count/datum.dart';
import '../../Model/Admin Dashboard/complaint_by_department_model/datum.dart';
import '../../Model/Admin Dashboard/dash_client_stat_model/dash_client_stat_model.dart';
import '../../Model/Admin Dashboard/dash_client_stat_model/datum.dart';
import '../../Model/Admin Dashboard/dash_recent_complaint_model/dash_recent_complaint_model.dart';
import '../../Model/Admin Dashboard/dash_recent_complaint_model/datum.dart';
import '../../Model/Admin Dashboard/header_model/header_model.dart';
import '../AuthController/AuthController.dart';

class DashboardController extends GetxController {
  final RxInt totalComplaints = 0.obs;
  final RxInt totalEquipment = 0.obs;
  final RxInt totalClients = 0.obs;
  final ApiService _apiService = ApiService();

  // complaint priority counts
  final RxInt urgent = 0.obs;
  final RxInt medium = 0.obs;
  final RxInt high = 0.obs;

  // lists
  final RxList<Datum> recentComplaints = <Datum>[].obs;
  final RxList<ClientStatModel> clientStats = <ClientStatModel>[].obs;
  final RxList<ActiveCount> activeWorkers = <ActiveCount>[].obs;
  final RxList<ComplaintWithDepartment> complaintsByDepartment =
      <ComplaintWithDepartment>[].obs;
  final Rx<DashStatic> dashStaticModel = DashStatic().obs;

  // flags - individual loading states for each section
  final RxBool loading = false.obs;
  final RxBool loadingTopCards = false.obs;
  final RxBool loadingPriorityChart = false.obs;
  final RxBool loadingClients = false.obs;
  final RxBool loadingRecentComplaints = false.obs;
  final RxBool loadingActiveWorkers = false.obs;
  final RxBool loadingHeader = false.obs;

  final String headerEndpoint =
      '/api/v1/admin/dashboard/complaints-by-priority';
  final String recentComplaintsEndpoint =
      '/api/v1/admin/dashboard/recent-complaints';
  final String clientStatsEndpoint = '/api/v1/admin/dashboard/client-stats';
  final String activeWorkersEndpoint =
      '/api/v1/admin/dashboard/workers-by-department';
  final String complaintsByDeptEndpoint =
      '/api/v1/admin/dashboard/complaints-by-department';
  final String dashStaticEndpoint = '/api/v1/admin/dashboard';

  // ========================
  // Helper: tries to normalize a GetConnect Response to a Map<String, dynamic>
  // Returns null when response is not OK or decode fails.
  // ========================
  Map<String, dynamic>? _decodeGetConnectResponse(Response r, String name) {
    try {
      if (!r.isOk || r.body == null) {
        print(
            'ApiService response not OK for $name -> status: ${r.statusCode}');
        return null;
      }

      final dynamic body = r.body;

      if (body is Map<String, dynamic>) {
        return body;
      } else if (body is String) {
        // sometimes GetConnect returns raw string
        final decoded = json.decode(body);
        if (decoded is Map<String, dynamic>) return decoded;
        return {'data': decoded};
      } else {
        // other types (e.g., List)
        return {'data': body};
      }
    } catch (e) {
      print('Error decoding GetConnect response for $name: $e');
      return null;
    }
  }

  // Optional validator to detect header-like JSON shape
  bool _looksLikeHeader(Map<String, dynamic> map) {
    final d = map['data'];
    if (d is Map<String, dynamic>) {
      return d.containsKey('urgent') &&
          d.containsKey('medium') &&
          d.containsKey('high');
    }
    return false;
  }

  /// Fetch dashboard by calling named endpoints via your ApiService.
  /// If [token] is null, will attempt to get token from AuthController.
  Future<void> fetchDashboard([String? token]) async {
    loading.value = true;

    // try to get token from AuthController if not provided

    if (token == null || token.isEmpty) {
      print('No token provided — aborting fetchDashboard.');
      loading.value = false;
      return;
    }

    // Set individual loading states
    loadingHeader.value = true;
    loadingTopCards.value = true;
    loadingPriorityChart.value = true;
    loadingClients.value = true;
    loadingRecentComplaints.value = true;
    loadingActiveWorkers.value = true;

    // Build named requests (endpoint path + name)
    final requests = [
      {'endpoint': headerEndpoint, 'name': 'header'},
      {'endpoint': recentComplaintsEndpoint, 'name': 'recent'},
      {'endpoint': clientStatsEndpoint, 'name': 'clients'},
      {'endpoint': activeWorkersEndpoint, 'name': 'activeWorkers'},
      {'endpoint': complaintsByDeptEndpoint, 'name': 'complaintsByDept'},
      {'endpoint': dashStaticEndpoint, 'name': "dashStatic"}
    ];

    try {
      // Create a list of futures that call ApiService.getRequest and return a map with name & response
      final futures = requests.map((r) {
        final String ep = r['endpoint'] as String;
        final String name = r['name'] as String;
        return _apiService
            .getRequest(ep, bearerToken: token)
            .then<Map<String, dynamic>>(
                (resp) => {'name': name, 'response': resp})
            .catchError((err) {
          print('Error calling $name ($ep): $err');
          return {'name': name, 'response': null};
        });
      }).toList();

      // Await all
      final results = await Future.wait(futures);

      // Prepare decoded maps
      Map<String, dynamic>? headerJson;
      Map<String, dynamic>? recentJson;
      Map<String, dynamic>? clientsJson;
      Map<String, dynamic>? activeWorkersJson;
      Map<String, dynamic>? complaintsByDeptJson;
      Map<String, dynamic>? dashStatic;

      // Process each result
      for (final r in results) {
        final String name = r['name'] as String;
        final Response? resp = r['response'] as Response?;
        if (resp == null) {
          print('No response for $name');
          continue;
        }
        final decoded = _decodeGetConnectResponse(resp, name);
        if (decoded == null) {
          print('Decoded null for $name');
          continue;
        }
        // assign by name
        if (name == 'header') {
          headerJson = decoded;
          loadingHeader.value = false;
          loadingPriorityChart.value = false;
        }
        if (name == 'recent') {
          recentJson = decoded;
          loadingRecentComplaints.value = false;
        }
        if (name == 'clients') {
          clientsJson = decoded;
          loadingClients.value = false;
        }
        if (name == 'activeWorkers') {
          activeWorkersJson = decoded;
          loadingActiveWorkers.value = false;
        }
        if (name == 'complaintsByDept') complaintsByDeptJson = decoded;
        if (name == "dashStatic") {
          dashStatic = decoded;
          loadingTopCards.value = false;
        }
      }

      // Fallback: if headerJson is missing or doesn't look right, try to find it among other decoded maps
      if (headerJson == null || !_looksLikeHeader(headerJson)) {
        final candidates = [
          recentJson,
          clientsJson,
          activeWorkersJson,
          complaintsByDeptJson,
          dashStatic
        ];
        for (final c in candidates) {
          if (c != null && _looksLikeHeader(c)) {
            print(
                'Found header-like response in a different endpoint; using it as header.');
            headerJson = c;
            break;
          }
        }
        if (headerJson == null) {
          print('Warning: header JSON not found among responses.');
        }
      }

      // Finally use your parsing logic
      loadFromApi(
          headerJson: headerJson,
          recentComplaintsJson: recentJson,
          clientStatsJson: clientsJson,
          activeWorkersJson: activeWorkersJson,
          complaintsByDepartmentJson: complaintsByDeptJson,
          dashStaticJson: dashStatic);
    } catch (e, st) {
      print('fetchDashboard unexpected error: $e\n$st');
    } finally {
      loading.value = false;
      // Reset individual loading states if still true
      loadingHeader.value = false;
      loadingTopCards.value = false;
      loadingPriorityChart.value = false;
      loadingClients.value = false;
      loadingRecentComplaints.value = false;
      loadingActiveWorkers.value = false;
    }
  }

  // Public method for user to call after receiving API JSONs
  // (keeps your original parsing logic — used by fetchDashboard)
  void loadFromApi(
      {Map<String, dynamic>? headerJson,
      Map<String, dynamic>? recentComplaintsJson,
      Map<String, dynamic>? clientStatsJson,
      Map<String, dynamic>? activeWorkersJson,
      Map<String, dynamic>? complaintsByDepartmentJson,
      Map<String, dynamic>? dashStaticJson}) {
    try {
      print('DashStatic JSON: $dashStaticJson');
      print("headerJson: $headerJson");

      if (headerJson != null) {
        final header = HeaderModel.fromJson(headerJson);
        urgent.value = header.data?.urgent ?? 0;
        medium.value = header.data?.medium ?? 0;
        high.value = header.data?.high ?? 0;
        totalComplaints.value = (header.data?.urgent ?? 0) +
            (header.data?.medium ?? 0) +
            (header.data?.high ?? 0);
      }

      if (recentComplaintsJson != null) {
        final recent = DashRecentComplaintModel.fromJson(recentComplaintsJson);
        recentComplaints.assignAll(recent.data ?? []);
      }

      if (clientStatsJson != null) {
        final clients = DashClientStatModel.fromJson(clientStatsJson);
        clientStats.assignAll(clients.data ?? []);
        totalClients.value = clients.data?.length ?? 0;
        // sum equipment if available
        totalEquipment.value = clients.data
                ?.fold(0, (prev, c) => prev! + (c.equipment?.total ?? 0)) ??
            0;
      }

      if (activeWorkersJson != null) {
        final aw = ActiveWorkerCount.fromJson(activeWorkersJson);
        activeWorkers.assignAll(aw.data ?? []);
      }

      if (complaintsByDepartmentJson != null) {
        final list = (complaintsByDepartmentJson['data'] as List?)
                ?.map((e) =>
                    ComplaintWithDepartment.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        complaintsByDepartment.assignAll(list);
      }
      if (dashStaticJson != null) {
        try {
          final staticData = DashStatic.fromJson(dashStaticJson['data']);
          dashStaticModel.value = staticData;
        } catch (e) {
          print('Error parsing dashStaticJson: $e');
        }
      }
    } catch (e) {
      print('Error parsing API data: $e');
    }
  }

  // Example: populate with fake sample data for previewing UI
  @override
  void onInit() {
    super.onInit();
    // Attempt automatic fetch using AuthController token (if available).
    // If you prefer to call fetchDashboard(token) from UI, remove this.
    fetchDashboard(token);
  }
}
