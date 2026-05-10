import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vault/SomeConstants.dart';
import 'package:vault/classes/Account.dart';
import 'package:vault/dbHandling.dart';
import 'package:vault/enums/categories.dart';
import 'package:vault/exporter.dart';
import 'package:vault/helper.dart';
import 'package:vault/pages/addPasswordPage.dart';
import 'package:vault/pages/loginPage.dart';
import 'package:vault/pages/registerPage.dart';
import 'package:vault/passwordGenerator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _editPasswordController = TextEditingController();
  TextEditingController _passwordLengthController = TextEditingController();

  TextEditingController _searchFieldController = TextEditingController();
  List<Account> _allAccounts = [];
  Map<String, List<Account>> _filteredAccountsBundles = {};
  Map<String, List<Account>> _accountBundles = {};
  String _filterString = "";
  bool _isLoading = true;
  bool _dataExists = false;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  bool _validateLength() {
    try {
      int length = int.parse(_passwordLengthController.text);
      if (length < 8 || length > 32) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void _cleanSearch() {
    if (!_isSearching) {
      setState(() {
        _filterString = "";
        _searchFieldController.text = "";
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    setState(() {
      _accountBundles = {};
    });

    _allAccounts = await DatabaseHelper().getAllAccounts();
    for (var account in _allAccounts) {
      if (_accountBundles.containsKey(account.category)) {
        _accountBundles[account.category]!.add(account);
      } else {
        _accountBundles[account.category] = [account];
      }
    }
    if (_accountBundles.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _dataExists = true;
      });
    } else {
      setState(() {
        _isLoading = false;

        _dataExists = false;
      });
    }
    if (_filterString.isEmpty) {
      setState(() {
        _filteredAccountsBundles = _accountBundles;
      });
      return;
    }

    setState(() {
      _filteredAccountsBundles = Map.fromEntries(
        _accountBundles.entries.where((entry) {
          return entry.key.toLowerCase().contains(_filterString.toLowerCase());
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.lock, color: GREENFOREGROUND),
        title: (_isSearching)
            ? Container(
                height: 50,
                child: TextField(
                  autofocus: true,
                  controller: _searchFieldController,
                  onChanged: (value) async {
                    setState(() {
                      _filterString = value;
                    });
                    _cleanSearch();
                    await _loadData();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search...",
                  ),
                ),
              )
            : const Text("Vault"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
              _cleanSearch();
            },
            icon: (_isSearching) ? Icon(Icons.close) : Icon(Icons.search),
          ),
          (_isSearching)
              ? SizedBox(width: 10)
              : PopupMenuButton(
                  onSelected: (value) async {
                    switch (value) {
                      case "export":
                        if (await Exporter.exportAccounts()) {
                          Helper.showSnackboar(
                            context,
                            "Export Successfull!\nSaved at Downloads/",
                          );
                        } else {
                          Helper.showSnackboar(context, "Export Failed!!");
                        }

                        break;
                      case "delete":
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.red),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Delete Confirmation",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight(500),
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                "Do you want to delete the database?\nThis action is irriversible.",
                              ),
                              actions: [
                                IconButton(
                                  onPressed: () async {
                                    await DatabaseHelper().removeDB();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return RegisterPage();
                                        },
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    color: GREENFOREGROUND,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close, color: Colors.red),
                                ),
                              ],
                            );
                          },
                        );
                        break;
                      case "logout":
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            },
                          ),
                        );
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
                        child: Text(
                          "Log Out",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ];
                  },
                ),
        ],
      ),
      body: (_isLoading)
          ? Center(child: CircularProgressIndicator())
          : (!_dataExists)
          ? Center(child: Text("No passwords added"))
          : GestureDetector(
              onTap: () {
                setState(() {
                  _isSearching = false;
                });
                _cleanSearch();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsetsGeometry.directional(
                  start: 12,
                  end: 12,
                  top: 20,
                  bottom: 20,
                ),
                child: ListView.builder(
                  itemCount: _filteredAccountsBundles.keys.length,
                  itemBuilder: (context, index) {
                    String key = _filteredAccountsBundles.keys.elementAt(index);
                    List<Account> accounts = _filteredAccountsBundles[key]!;
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
                                image: accounts.first.icon.imageAsset,
                                fit: BoxFit.cover,
                              ),
                            ),
                            backgroundColor: TILECOLOR,
                            title: Text(
                              key,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              (accounts.length > 1)
                                  ? "${accounts.length} accounts saved."
                                  : "${accounts.length} account saved",
                              style: TextStyle(color: GREYTEXT, fontSize: 12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(12),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.keyboard_arrow_down),
                            ),
                            onExpansionChanged: (value) {},
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: accounts.length,
                                itemBuilder: (context, index) {
                                  Account account = accounts[index];
                                  return ListTile(
                                    title: Text(
                                      account.username,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      account.password,
                                      style: TextStyle(color: GREYTEXT),
                                    ),
                                    onTap: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: account.password),
                                      );
                                      Helper.showSnackboar(
                                        context,
                                        "Copied password to clipboard",
                                      );
                                      log("Copied");
                                    },
                                    trailing: PopupMenuButton(
                                      onSelected: (value) async {
                                        switch (value) {
                                          case "edit":
                                            await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  scrollable: true,

                                                  title: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.lock,
                                                        color: GREENFOREGROUND,
                                                      ),
                                                      SizedBox(width: 12),
                                                      Text(
                                                        "Edit password",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("New Password"),
                                                      Container(
                                                        height: 40,
                                                        child: TextField(
                                                          controller:
                                                              _editPasswordController,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              if (_validateLength()) {
                                                                String
                                                                generatedPassword =
                                                                    generatePassword(
                                                                      int.parse(
                                                                        _passwordLengthController
                                                                            .text,
                                                                      ),
                                                                    );
                                                                setState(() {
                                                                  _editPasswordController
                                                                          .text =
                                                                      generatedPassword;
                                                                });
                                                                log(
                                                                  generatedPassword,
                                                                );
                                                              } else {
                                                                Helper.showSnackboar(
                                                                  context,
                                                                  "Invalid length, Make sure length is more than 7 and less than 33",
                                                                  color: Colors
                                                                      .red,
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              "Generate password of length",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 50,
                                                            width: 50,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  10,
                                                                ),

                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border: Border.all(
                                                                color:
                                                                    BORDERCOLOR,
                                                              ),
                                                            ),
                                                            child: TextField(
                                                              controller:
                                                                  _passwordLengthController,
                                                              maxLength: 2,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,

                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                              decoration:
                                                                  InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        if (_editPasswordController
                                                            .text
                                                            .isEmpty) {
                                                          Helper.showSnackboar(
                                                            context,
                                                            "Empty Password Field.",
                                                          );
                                                          return;
                                                        }
                                                        Account
                                                        newAccount = Account(
                                                          id: account.id,
                                                          icon: account.icon,
                                                          category:
                                                              account.category,
                                                          username:
                                                              account.username,
                                                          password:
                                                              _editPasswordController
                                                                  .text,
                                                        );
                                                        await DatabaseHelper()
                                                            .updateAccount(
                                                              newAccount,
                                                            );
                                                        await _loadData();
                                                        setState(() {
                                                          _editPasswordController
                                                                  .text =
                                                              "";
                                                          _passwordLengthController
                                                                  .text =
                                                              "";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                        Icons.check,
                                                        color: GREENFOREGROUND,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _editPasswordController
                                                                  .text =
                                                              "";
                                                          _passwordLengthController
                                                                  .text =
                                                              "";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
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
                                                      onPressed: () async {
                                                        await DatabaseHelper()
                                                            .removeAccount(
                                                              account.id!,
                                                            );
                                                        await _loadData();
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                        Icons.check,
                                                        color: GREENFOREGROUND,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
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
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: "delete",
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
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
            ),
      floatingActionButton: IconButton(
        onPressed: () async {
          bool shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddPasswordPage();
              },
            ),
          );
          if (shouldRefresh) {
            _loadData();
          }
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
