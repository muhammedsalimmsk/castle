import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PartsRequestPage extends StatelessWidget {
  const PartsRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        title: Text(
          "Parts Request",
          style: TextStyle(color: containerColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search here..",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: containerColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // spacing between field and button
                Container(
                  height: 58,
                  width: 58, // match TextFormField height
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: containerColor),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: backgroundColor,
                    ),
                    onPressed: () {
                      // add your search function here
                    },
                  ),
                ),
              ],
            ),
            Gap(10),
            Text(
              "Parts List",
              style: TextStyle(
                  color: containerColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Container(
              height: 590,
              child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(
                        "562969",
                        style: TextStyle(
                            color: containerColor, fontWeight: FontWeight.bold),
                      ),
                      title: Text("Parts Name"),
                      subtitle: Text("Stock : 32"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Available",
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                          Gap(10),
                          Icon(Icons.more_vert_outlined)
                        ],
                      ),
                    );
                  }),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  "Request Now",
                  style: TextStyle(
                      color: backgroundColor, fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
