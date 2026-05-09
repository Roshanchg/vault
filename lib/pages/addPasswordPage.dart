import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vault/SomeConstants.dart';
import 'package:vault/classes/Account.dart';
import 'package:vault/dbHandling.dart';
import 'package:vault/enums/categories.dart';
import 'package:vault/helper.dart';
import 'package:vault/passwordGenerator.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key});
  @override
  State<AddPasswordPage> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  TextEditingController _categoryFieldController = TextEditingController();
  TextEditingController _usernameFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();
  TextEditingController _passwordLengthController = TextEditingController();

  CATEGORIES _selectedCategory = CATEGORIES.DEFAULT;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onSubmit() async {
    CATEGORIES iconCat = _selectedCategory;
    String category = _categoryFieldController.text;
    String username = _usernameFieldController.text;
    String password = _passwordFieldController.text;

    Account newAccount = Account(
      icon: iconCat,
      category: category,
      username: username,
      password: password,
    );
    log(newAccount.toString());
    await DatabaseHelper().addAccount(newAccount);
  }

  bool _validateAllFields() {
    if (_categoryFieldController.text.isEmpty) {
      Helper.showSnackboar(context, "Empty Category Field");
      return false;
    }
    if (_usernameFieldController.text.isEmpty) {
      Helper.showSnackboar(context, "Empty Username Field");
      return false;
    }
    if (_passwordFieldController.text.isEmpty) {
      Helper.showSnackboar(context, "Empty Password Field");
      return false;
    }
    return true;
  }

  bool _validateLengthField() {
    try {
      int length = int.parse(_passwordLengthController.text);
      if (length < 8) {
        Helper.showSnackboar(
          context,
          "Too small length field, must be more than or equal to 8",
        );
        return false;
      }
      if (length > 32) {
        Helper.showSnackboar(context, "Choose length less than or equal to 32");
        return false;
      }
      return true;
    } catch (e) {
      Helper.showSnackboar(context, "Invalid Length value.");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vault"),
        toolbarHeight: 44,
        leading: IconButton(
          onPressed: () {
            if (mounted) {
              Navigator.pop(context, false);
            }
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: Container(
        padding: EdgeInsetsGeometry.directional(
          top: 20,
          end: 18,
          start: 18,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "New Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight(500)),
            ),
            const SizedBox(height: 12),
            const Text("Select Icon"),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),

              clipBehavior: Clip.none,
              itemCount: CATEGORIES.values.length,
              itemBuilder: (context, index) {
                CATEGORIES iconName = CATEGORIES.values.elementAt(index);
                return Container(
                  decoration: BoxDecoration(
                    color: DARKBACKGROUND,
                    border: Border.all(
                      color: (_selectedCategory == iconName)
                          ? GREENFOREGROUND
                          : BORDERCOLOR,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = iconName;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: iconName.imageAsset,
                          height: 20,
                          width: 20,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 8),
                        Text(
                          iconName.prettyName,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text("Category"),
            const SizedBox(height: 8),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: BORDERCOLOR),
                color: DARKBACKGROUND,
              ),
              child: TextField(
                controller: _categoryFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "e.g. Bank, Google, Facebook",
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text("Username"),
            const SizedBox(height: 8),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: BORDERCOLOR),
                color: DARKBACKGROUND,
              ),
              child: TextField(
                controller: _usernameFieldController,
                decoration: InputDecoration(
                  hintText: "email or password",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff0a0a0a),
                border: Border.all(color: BORDERCOLOR),
              ),
              padding: EdgeInsetsGeometry.directional(
                top: 8,
                start: 14,
                end: 14,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Password"),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: BORDERCOLOR),
                    ),
                    child: TextField(
                      controller: _passwordFieldController,
                      decoration: InputDecoration(
                        hintText: "Password ...",
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: BORDERCOLOR),
                  Row(
                    children: [
                      Icon(Icons.replay_5_outlined, color: Colors.blue),
                      TextButton(
                        onPressed: () {
                          if (_validateLengthField()) {
                            String generatedPassword = generatePassword(
                              int.parse(_passwordLengthController.text),
                            );
                            setState(() {
                              _passwordFieldController.text = generatedPassword;
                            });
                          }
                        },
                        child: Text(
                          "Generate Password",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight(500),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Length",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 34,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(color: BORDERCOLOR),
                              ),
                              padding: EdgeInsetsGeometry.directional(start: 4),
                              child: TextField(
                                controller: _passwordLengthController,
                                maxLines: 1,
                                maxLength: 2,
                                style: TextStyle(fontSize: 12),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: GREENFOREGROUND,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  if (_validateAllFields()) {
                    await _onSubmit();
                    setState(() {
                      _passwordLengthController.text = "";
                    });
                    Navigator.pop(context, true);
                  }
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      "Save Account",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
