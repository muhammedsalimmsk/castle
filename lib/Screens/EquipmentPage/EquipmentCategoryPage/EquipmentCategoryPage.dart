import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Colors/Colors.dart';
import 'package:castle/Utils/ResponsiveHelper.dart';

import '../../../Controlls/EquipCategoryController/EquipCategoryController.dart';
import 'CategoryDetailsPage.dart';

class EquipmentCategoryPage extends StatelessWidget {
  const EquipmentCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EquipmentCategoryController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: buttonColor),
        title: Text("Categories",
            style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Column(
              children: [
                // Modern Header Section
                Container(
                  padding: ResponsiveHelper.getResponsivePadding(context),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: cardShadowColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: buttonColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: buttonColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${controller.catList.length} Categories",
                        style: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                top: 12,
                bottom: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: searchBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search categories...",
                    hintStyle: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: buttonColor,
                      size: 22,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: buttonColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor: searchBackgroundColor,
                  ),
                ),
              ),
            ),
            // Categories List
            Expanded(
              child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Loading categories...",
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (controller.catList.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          controller.catList.clear();
                          await controller.getCategory();
                        },
                        color: buttonColor,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 100),
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: searchBackgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.category_outlined,
                                      size: 64,
                                      color: subtitleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "No categories found",
                                    style: TextStyle(
                                      color: containerColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Add new categories to get started",
                                    style: TextStyle(
                                      color: subtitleColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ResponsiveHelper.isLargeScreen(context)
                        ? RefreshIndicator(
                            onRefresh: () async {
                              controller.catList.clear();
                              await controller.getCategory();
                            },
                            color: buttonColor,
                            child: GridView.builder(
                              padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                top: 0,
                              ),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 12,
                                childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1.3 : 1.2,
                              ),
                              itemCount: controller.catList.length,
                              itemBuilder: (context, index) {
                                final category = controller.catList[index];
                                return _buildCategoryCard(category);
                              },
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              controller.catList.clear();
                              await controller.getCategory();
                            },
                            color: buttonColor,
                            child: ListView.builder(
                              padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                top: 0,
                              ),
                              itemCount: controller.catList.length,
                              itemBuilder: (context, index) {
                                final category = controller.catList[index];
                                return _buildCategoryCard(category);
                              },
                            ),
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              buttonColor,
              buttonColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            showCreateCategoryDialog(context, controller);
          },
          child: Icon(Icons.add, color: backgroundColor),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(dynamic category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed('/categoryDetails', arguments: {'category': category});
          },
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
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        buttonColor,
                        buttonColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.category_rounded,
                    color: backgroundColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category.name ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (category.description != null && category.description!.isNotEmpty)
                        Text(
                          category.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: subtitleColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Arrow
                Icon(
                  Icons.chevron_right,
                  color: subtitleColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCreateCategoryDialog(
      BuildContext context, EquipmentCategoryController controller) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    "Create Category",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name field
                  TextFormField(
                    controller: nameController,
                    cursorColor: buttonColor,
                    decoration: InputDecoration(
                      labelText: "Category Name",
                      labelStyle: TextStyle(color: containerColor),
                      hintText: "Enter category name",
                      hintStyle: TextStyle(color: buttonColor.withOpacity(0.6)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter category name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Description field
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    cursorColor: buttonColor,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: containerColor),
                      hintText: "Enter category description",
                      hintStyle: TextStyle(color: buttonColor.withOpacity(0.6)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: controller.isLoading1.value
                            ? null
                            : () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onPressed: controller.isLoading1.value
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  controller.createCategory(
                                    nameController.text.trim(),
                                    descriptionController.text.trim(),
                                  );
                                }
                              },
                        child: controller.isLoading1.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Create",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
