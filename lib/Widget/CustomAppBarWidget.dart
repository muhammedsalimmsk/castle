import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Screens/ProfiePage/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(userDetailModel?.data?.firstName);
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left-side elements
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu, color: buttonColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userDetailModel!.data!.firstName} ${userDetailModel!.data!.lastName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          userDetailModel!.data!.role!,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        if (userDetailModel!.data!.badges != null &&
                            userDetailModel!.data!.badges!.isNotEmpty)
                          ...userDetailModel!.data!.badges!.map((badge) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: buttonColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: buttonColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  badge,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: buttonColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Right-side elements
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/profile');
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: buttonColor,
                    child: Text(
                      '${userDetailModel?.data?.firstName?.substring(0, 1).toUpperCase() ?? ''}'
                      '${userDetailModel?.data?.lastName?.substring(0, 1).toUpperCase() ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
