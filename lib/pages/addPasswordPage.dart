import 'package:flutter/material.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key});
  @override
  State<AddPasswordPage> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vault"),
        leading: IconButton(
          onPressed: () {
            if (mounted) {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: Center(child: Text("NAH")),
    );
  }
}
