import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Colors/Colors.dart';

import '../../../Controlls/EquipCategoryController/EquipCategoryController.dart';
import '../../../Model/equipment_category_model/datum.dart';

class CategoryDetailsPage extends StatelessWidget {
  final EquipCat category;
  const CategoryDetailsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    EquipmentCategoryController controller = Get.find();
    TextEditingController nameController =
        TextEditingController(text: category.name);
    TextEditingController descriptionController =
        TextEditingController(text: category.description);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name ?? "",
          style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: buttonColor),
        actions: [
          IconButton(
              onPressed: () {
                showUpdateCategoryDialog(
                    nameController, descriptionController, context, controller);
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete",
                  middleText: "Are you sure want to delete?",
                  barrierDismissible: false,
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: buttonColor),
                      ),
                    ),
                    Obx(() {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.isDeleting.value
                            ? null
                            : () {
                                controller.deleteCategory(category.id!);
                              },
                        child: controller.isDeleting.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Delete",
                                style: TextStyle(color: Colors.white)),
                      );
                    }),
                  ],
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Info Card
            Container(
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(16)),
              child: Card(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.description ?? "No description available",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.inventory, color: buttonColor),
                          const SizedBox(width: 6),
                          Text(
                            "Equipment: ${category.count?.equipment ?? 0}",
                            style: TextStyle(
                              fontSize: 14,
                              color: buttonColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Subcategories Header
            // Subcategories Header + List
            GetBuilder<EquipmentCategoryController>(
              builder: (controller) {
                // Get the latest version of this category from controller
                final updatedCategory = controller.catList
                    .firstWhereOrNull((c) => c.id == category.id);

                if (updatedCategory == null) {
                  return const Text("Category not found");
                }

                final subCategories = updatedCategory.subCategories ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subcategories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: buttonColor,
                          ),
                        ),
                        Text(
                          "${subCategories.length} items",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // List
                    if (subCategories.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "No subcategories available",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final sub = subCategories[index];
                          TextEditingController subCatName =
                              TextEditingController(text: sub.name);
                          TextEditingController subCatDescr =
                              TextEditingController(text: sub.description);
                          return Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: buttonColor.withOpacity(0.15),
                                child: Icon(Icons.category, color: buttonColor),
                              ),
                              title: Text(
                                sub.name ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(sub.description ?? ""),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showUpdateSubcategoryDialog(
                                            context,
                                            controller,
                                            subCatName,
                                            subCatDescr,
                                            sub.id!);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: buttonColor,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        Get.dialog(
                                          AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            backgroundColor: Colors
                                                .white, // or your custom backgroundColor
                                            title: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: const Text(
                                              "Are you sure you want to delete this item?",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            actionsPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10),
                                            actions: [
                                              // Cancel button
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  elevation: 0,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                ),
                                              ),

                                              // Delete button
                                              Obx(
                                                () => controller
                                                        .isDeleting.value
                                                    ? CircularProgressIndicator(
                                                        color: buttonColor,
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: () async {
                                                          // Call your delete function here
                                                          // controller.deleteItem(id);
                                                          await controller
                                                              .deleteSubCat(
                                                                  sub.id!,
                                                                  category.id!);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              buttonColor,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: buttonColor,
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        child: Icon(Icons.add, color: backgroundColor),
        onPressed: () {
          // Show add subcategory dialog
          final controller = Get.find<EquipmentCategoryController>();
          showCreateCategoryDialog(context, controller);
        },
      ),
    );
  }

  void showUpdateCategoryDialog(
      final TextEditingController nameController,
      final TextEditingController descriptionController,
      BuildContext context,
      EquipmentCategoryController controller) {
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
                    "Update Category",
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
                        onPressed: controller.isUpdating.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await controller.updateCategory(
                                      catId: category.id!,
                                      name: nameController.text,
                                      description: descriptionController.text);
                                }
                              },
                        child: controller.isUpdating.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Update",
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

  void showCreateCategoryDialog(
      BuildContext context, EquipmentCategoryController controller) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    "Create Subcategory",
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
                      labelText: "Subcategory Name",
                      labelStyle: TextStyle(color: containerColor),
                      hintText: "Enter subcategory name",
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
                        return "Please enter subcategory name";
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
                      hintText: "Enter subcategory description",
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
                                if (formKey.currentState!.validate()) {
                                  controller.createSubCategory(
                                      nameController.text.trim(),
                                      descriptionController.text.trim(),
                                      category.id!);
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

  void showUpdateSubcategoryDialog(
      BuildContext context,
      EquipmentCategoryController controller,
      TextEditingController nameController,
      TextEditingController descriptionController,
      String subCatId) {
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    "Update Subcategory",
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
                      labelText: "Subcategory Name",
                      labelStyle: TextStyle(color: containerColor),
                      hintText: "Enter subcategory name",
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
                        return "Please enter subcategory name";
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
                      hintText: "Enter subcategory description",
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
                        onPressed: controller.isUpdating.value
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  controller.updateSubCat(
                                      subCatId: subCatId,
                                      name: nameController.text,
                                      description: descriptionController.text,
                                      catId: category.id!);
                                }
                              },
                        child: controller.isUpdating.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Update",
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
