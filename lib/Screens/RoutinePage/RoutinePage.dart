import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RoutinePage extends StatelessWidget {
  const RoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Routine",
          style: TextStyle(color: containerColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Search here..",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: containerColor)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: containerColor))),
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Routine",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.sort),
                  onSelected: (value) {
                    // handle the selected sort option
                    print("Selected: $value");
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'name',
                      child: Text('Sort by Name'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'date',
                      child: Text('Sort by Date'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'priority',
                      child: Text('Sort by Priority'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 560,
              child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://www.voltasbeko.com/media/catalog/product/v/w/vwm915647-final-copy.jpg'))),
                      ),
                      title: Text(
                        "Washing Mechine",
                        style: TextStyle(color: containerColor),
                      ),
                      subtitle: Text("Brad Mason"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete)),
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Add New",
                  style: TextStyle(color: backgroundColor),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
