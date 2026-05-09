import 'dart:math';

final Random _secureRandom = Random.secure();
String generatePassword(int length) {
  String finalPassword = "";
  String specialChars = '!@#\$%^&*_-=+()/*[]{}?<>';
  String alphabets = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  int leftSize = length;
  int numberSize = 1 + _secureRandom.nextInt(leftSize ~/ 2);
  for (var i = 0; i < numberSize; i++) {
    finalPassword += _secureRandom.nextInt(10).toString();
  }
  leftSize -= numberSize;
  int temp = 0;
  temp = 1 + _secureRandom.nextInt(leftSize - 3);
  leftSize -= temp;
  for (var i = 0; i < temp; i++) {
    finalPassword += specialChars[_secureRandom.nextInt(specialChars.length)];
  }
  for (var i = 0; i < leftSize; i++) {
    finalPassword += alphabets[_secureRandom.nextInt(alphabets.length)];
  }
  List<String> tempPass = finalPassword.split("");
  tempPass.shuffle(_secureRandom);
  finalPassword = tempPass.join("");
  return finalPassword;
}
