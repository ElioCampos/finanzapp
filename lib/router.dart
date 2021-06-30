import 'package:finanzapp/pages/add_wallet.dart';
import 'package:finanzapp/pages/options.dart';
import 'package:finanzapp/pages/wallet_details.dart';
import 'package:flutter/material.dart';
import 'pages/add_letter.dart';
import 'pages/home_page.dart';
import 'pages/letter_details.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/wallet_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var id = settings.arguments as int;
  // var userId = settings.arguments;
  switch (settings.name) {
    case 'login':
      return MaterialPageRoute(builder: (context) => LoginPage());
    case 'register':
      return MaterialPageRoute(builder: (context) => RegisterPage());
    case 'home':
      return MaterialPageRoute(builder: (context) => HomePage());
    case 'wallets':
      return MaterialPageRoute(builder: (context) => WalletPage());
    case 'options':
      return MaterialPageRoute(builder: (context) => OptionsPage());
    case 'wallet_details':
      return MaterialPageRoute(builder: (context) => WalletDetails(walletId: id,));
    case 'letter_details':
      return MaterialPageRoute(builder: (context) => LetterDetails(letterId: id,));
    case 'add_wallet':
      return MaterialPageRoute(builder: (context) => AddWallet());
    case 'add_letter':
      return MaterialPageRoute(builder: (context) => AddLetter(walletId: id));
    default:
      return MaterialPageRoute(builder: (context) => LoginPage());
  }
}