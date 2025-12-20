import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Screens/LoginPage/LoginPage.dart';
import 'package:castle/Screens/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Colors/Colors.dart';
import 'Model/auth_model/auth_model.dart';
import 'Screens/ClientPage/ClientPage.dart';
import 'Screens/ComplaintsPage/ComplaintPage.dart';
import 'Screens/EquipmentPage/EquipmentPage.dart';
import 'Screens/HomePage/AdminHomePage.dart';
import 'Screens/HomePage/ClientHomePage.dart';
import 'Screens/HomePage/WorkerHomePage.dart';
import 'Screens/InvoicePage/InvoiceListPage.dart';
import 'Screens/PartsRequestPagee/PartsListPage.dart';
import 'Screens/PartsRequestPagee/PartsRequestPage.dart';
import 'Screens/RoutineScreens/RoutinePage/RoutinePage.dart';
import 'Screens/RoutineScreens/WorkerRoutinePage.dart';
import 'Screens/WorkersPage/WorkersPage.dart';
import 'Services/ApiService.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// Import all screen files
import 'Screens/ClientPage/ClientDetailsPage.dart';
import 'Screens/ClientPage/ClientRegisterPage.dart';
import 'Screens/ClientPage/ClientRegisterTwo.dart';
import 'Screens/ClientPartPage/ClientPartsPage.dart';
import 'Screens/ComplaintsPage/ComplaintDetailsPage.dart';
import 'Screens/ComplaintsPage/NewComplaint/NewComplaintPage.dart';
import 'Screens/ComplaintsPage/AssignWorkPage/AssignWorkPage.dart';
import 'Screens/EquipmentPage/EquipmentDetails/EquipmentDetails.dart';
import 'Screens/EquipmentPage/EquipmentDetails/ClientAddPage.dart';
import 'Screens/EquipmentPage/NewEquipments.dart';
import 'Screens/EquipmentPage/UpdatePage/EquipmentUpdatePage.dart';
import 'Screens/EquipmentPage/EquipmentCategoryPage/EquipmentCategoryPage.dart';
import 'Screens/EquipmentPage/EquipmentCategoryPage/CategoryDetailsPage.dart';
import 'Screens/EquipmentPage/EquipmentTypePage/EquipmentTypePage.dart';
import 'Screens/EquipmentPage/EquipmentTypePage/EquipTypeDetails.dart';
import 'Screens/InvoicePage/InvoiceDetailsPage.dart';
import 'Screens/InvoicePage/CreateInvoicePage.dart';
import 'Screens/LoginDetailsPage/LoginDetailsPage.dart';
import 'Screens/PartsRequestPagee/PartsDetailsPage.dart';
import 'Screens/PartsRequestPagee/NewPartsPage.dart';
import 'Screens/PartsRequestPagee/RequestedPartsDetailPage.dart';
import 'Screens/PartsRequestPagee/RequestedPartWorkerPage.dart';
import 'Screens/ProfiePage/ProfilePage.dart';
import 'Screens/RoutineScreens/RoutineDetails/RoutineDetails.dart';
import 'Screens/RoutineScreens/RoutineDetails/RoutineUpdatePage.dart';
import 'Screens/RoutineScreens/AssignRoutinePage/AssignRoutinePage.dart';
import 'Screens/RoutineScreens/RoutineTaskPage.dart';
import 'Screens/RoutineScreens/RoutineTaskDetailPage.dart';
import 'Screens/WorkersPage/CreateWorker.dart';
import 'Screens/WorkersPage/WorkerDetailsPage.dart';
import 'Screens/WorkersPage/Departments/DepartmentListPage.dart';
import 'Screens/WorkersPage/Departments/NewDepartmentPage.dart';
import 'Model/equipment_model/datum.dart';
import 'Model/routine_model/datum.dart';
import 'Model/equipment_category_model/datum.dart';
import 'Model/equipment_type_list_model/datum.dart';
import 'Model/parts_list_model/datum.dart';
import 'Model/workers_model/datum.dart';
import 'Model/requested_parts_model/datum.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.initialize("7013c88e-2296-421e-a136-1c775c6904cc");
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  runApp(const MyApp());
}

Future<bool> checkTokenStatus() async {
  final prefs = await SharedPreferences.getInstance();

  final jwToken = prefs.getString('token');
  token = jwToken;

  final refreshToken = prefs.getString('refreshToken');
  final expiresAtStr = prefs.getString('expiresAt');

  if (token == null || refreshToken == null || expiresAtStr == null) {
    return false;
  }

  final expiresAt = DateTime.tryParse(expiresAtStr);
  if (expiresAt == null) return false;

  final now = DateTime.now();

  if (now.isAfter(expiresAt)) {
    try {
      final apiService = ApiService();
      final response = await apiService.postRequest(
        '/api/v1/auth/refresh',
        {'refreshToken': refreshToken},
      );

      if (response.isOk) {
        final model = AuthModel.fromJson(response.body);
        await prefs.setString('token', model.data?.token ?? '');
        await prefs.setString('refreshToken', model.data?.refreshToken ?? '');
        await prefs.setString(
          'expiresAt',
          model.data?.expiresAt?.toIso8601String() ?? '',
        );
        return true;
      } else {
        return false; // Refresh failed
      }
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  } else {
    return true; // Token still valid
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        fontFamily: GoogleFonts.ptSans().fontFamily, // 👈 Add this line
        textTheme: GoogleFonts.ptSansTextTheme().apply(
          bodyColor: containerColor,
          displayColor: containerColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
      ),
      getPages: [
        // Home Pages
        GetPage(name: '/home', page: () => DashboardPage()),
        GetPage(name: '/workerHome', page: () => WorkerHomePage()),
        GetPage(name: '/clientHome', page: () => ClientHomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        
        // Client Pages
        GetPage(name: '/clients', page: () => ClientPage()),
        GetPage(name: '/clientDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return ClientDetailPage(clientId: args['clientId'] as String);
        }),
        GetPage(name: '/clientRegister', page: () => ClientRegisterOne()),
        GetPage(name: '/clientRegisterTwo', page: () => ClientRegisterPageTwo()),
        GetPage(name: '/clientParts', page: () => RequestedPartsListPage()),
        
        // Worker Pages
        GetPage(name: '/workers', page: () => WorkersPage()),
        GetPage(name: '/workerDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return WorkerDetailsPage(worker: args['worker'] as WorkerData);
        }),
        GetPage(name: '/createWorker', page: () {
          final args = Get.arguments as Map<String, dynamic>?;
          return CreateWorker(workerId: args?['workerId'] as String?);
        }),
        GetPage(name: '/departments', page: () => DepartmentPage()),
        GetPage(name: '/newDepartment', page: () => NewDepartmentPage()),
        
        // Equipment Pages
        GetPage(name: '/equipment', page: () => EquipmentPage()),
        GetPage(name: '/equipmentDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return EquipmentDetailsPage(equipment: args['equipment'] as EquipmentDetailData);
        }),
        GetPage(name: '/equipmentUpdate', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return UpdateEquipmentPage(equipmentId: args['equipmentId'] as String);
        }),
        GetPage(name: '/clientAdd', page: () => ClientAddPage()),
        GetPage(name: '/newEquipment', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return NewEquipmentsRequest(clientId: args['clientId'] as String);
        }),
        GetPage(name: '/equipmentCategory', page: () => EquipmentCategoryPage()),
        GetPage(name: '/categoryDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return CategoryDetailsPage(category: args['category'] as EquipCat);
        }),
        GetPage(name: '/equipmentType', page: () => EquipmentTypePage()),
        GetPage(name: '/equipTypeDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return EquipTypeDetails(equipTypeDetails: args['equipTypeDetails'] as EquipmentType);
        }),
        
        // Complaint Pages
        GetPage(name: '/complaints', page: () => ComplaintPage()),
        GetPage(name: '/complaintDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return ComplaintDetailsPage(complaintId: args['complaintId'] as String);
        }),
        GetPage(name: '/newComplaint', page: () => NewComplaintRegister()),
        GetPage(name: '/assignWork', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return AssignWorkPage(
            complaintId: args['complaintId'] as String,
            isUpdating: args['isUpdating'] as bool? ?? false,
          );
        }),
        
        // Parts Request Pages
        GetPage(name: '/partsList', page: () => PartsListPage()),
        GetPage(name: '/partsDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return PartsDetailsPage(part: args['part'] as PartsDetail);
        }),
        GetPage(name: '/newPart', page: () => PartRegisterPage()),
        GetPage(name: '/requestedParts', page: () => RequestedPartsPage()),
        GetPage(name: '/requestedPartDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return RequestedPartDetailPage(partData: args['partData'] as RequestedParts);
        }),
        GetPage(name: '/requestedPartWorker', page: () => RequestedPartsWorkerPage()),
        
        // Invoice Pages
        GetPage(name: '/invoices', page: () => InvoiceListPage()),
        GetPage(name: '/invoiceDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return InvoiceDetailsPage(invoiceId: args['invoiceId'] as String);
        }),
        GetPage(name: '/createInvoice', page: () => CreateInvoicePage()),
        
        // Routine Pages
        GetPage(name: '/routine', page: () => RoutinePage()),
        GetPage(name: '/workerRoutine', page: () => WorkerRoutinePage()),
        GetPage(name: '/routineDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return RoutineDetailsPage(detail: args['detail'] as RoutineDetail);
        }),
        GetPage(name: '/routineUpdate', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return UpdateRoutinePage(routineDetail: args['routineDetail'] as RoutineDetail);
        }),
        GetPage(name: '/assignRoutine', page: () => AssignRoutinePage()),
        GetPage(name: '/routineTask', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return TaskListPage(routineId: args['routineId'] as String);
        }),
        GetPage(name: '/taskDetail', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return TaskDetailPage(taskId: args['taskId'] as String);
        }),
        
        // Login Details
        GetPage(name: '/loginDetails', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return LoginDetailsPage(
            userId: args['userId'] as String,
            userName: args['userName'] as String?,
            isClient: args['isClient'] as bool? ?? true,
          );
        }),
      ],
      home: SplashScreen(),
    );
  }
}
