import 'package:flutter/material.dart';
import 'package:vault/SomeConstants.dart';
import 'package:vault/pages/loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        color: null,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color.fromARGB(254, 9, 9, 9)),
        child: Stack(
          children: [
            Image(
              image: AssetImage("assets/login_background.png"),

              fit: BoxFit.cover,
            ),
            Container(
              alignment: AlignmentGeometry.center,
              padding: EdgeInsetsGeometry.directional(top: 50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.lock, color: GREENFOREGROUND, size: 36),
                      const SizedBox(width: 2),
                      Text(
                        "Vault",
                        style: TextStyle(
                          fontSize: 36,
                          color: GREENFOREGROUND,
                          fontWeight: FontWeight(600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Create New Pin",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight(500)),
                  ),
                  Text(
                    "If pin existed before, it will be overwritten!",
                    style: TextStyle(color: GREYTEXT),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    height: 20,
                    alignment: AlignmentGeometry.center,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 16,
                          width: 16,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),

                          margin: EdgeInsets.symmetric(horizontal: 4),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsGeometry.directional(
                      top: 12,
                      start: 12,
                      end: 12,
                    ),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.25,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _getTextButton("1"),
                        _getTextButton("2"),
                        _getTextButton("3"),
                        _getTextButton("4"),
                        _getTextButton("5"),
                        _getTextButton("6"),
                        _getTextButton("7"),
                        _getTextButton("8"),
                        _getTextButton("9"),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.backspace,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        _getTextButton("0"),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.check_circle,
                            color: GREENFOREGROUND,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Remember Pin? Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight(400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton _getTextButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight(400),
          fontSize: 36,
        ),
      ),
    );
  }
}
