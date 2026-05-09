import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vault/SomeConstants.dart';
import 'package:vault/enums/categories.dart';
import 'package:vault/pages/addPasswordPage.dart';
import 'package:vault/pages/loginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.lock, color: GREENFOREGROUND),
        title: const Text("Vault"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case "export":
                  log(value);
                  break;
                case "delete":
                  log(value);
                case "logout":
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      },
                    ),
                  );
                  log(value);
                  break;
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  value: "export",
                  child: Text(
                    "Export Passwords",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: "delete",
                  child: Text(
                    "Remove all Passwords",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: "logout",
                  child: Text("Log Out", style: TextStyle(color: Colors.white)),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsetsGeometry.directional(
          start: 12,
          end: 12,
          top: 20,
          bottom: 20,
        ),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BORDERCOLOR),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsetsGeometry.directional(
                      top: 10,
                      bottom: 10,
                      start: 20,
                      end: 10,
                    ),

                    leading: Container(
                      height: 32,
                      width: 32,
                      child: Image(
                        image: CATEGORIES.GITHUB.imageAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                    backgroundColor: TILECOLOR,
                    title: Text(
                      "ACCOUNT CATEGORY",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "AMOUNT OF ACCOUNT SAVED",
                      style: TextStyle(color: GREYTEXT, fontSize: 12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_down),
                    ),
                    onExpansionChanged: (value) {
                      log("tapped at index, $index, $value");
                    },
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              "chgroshan@gmail.com",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "passwordhere",
                              style: TextStyle(color: GREYTEXT),
                            ),
                            onTap: () {},
                            trailing: PopupMenuButton(
                              onSelected: (value) async {
                                switch (value) {
                                  case "edit":
                                    break;
                                  case "delete":
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          scrollable: false,
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "Do you want to delete that password?",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: const Text(
                                            "This action is irreversible.",
                                          ),
                                          actions: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.check,
                                                color: GREENFOREGROUND,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (context) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem(
                                    value: "edit",
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ];
                              },
                              child: Icon(Icons.more_vert, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddPasswordPage();
              },
            ),
          );
        },

        style: IconButton.styleFrom(
          backgroundColor: GREENFOREGROUND,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          shadowColor: GREENFOREGROUND,
        ),

        icon: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
