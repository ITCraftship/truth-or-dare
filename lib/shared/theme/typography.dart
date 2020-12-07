import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle semiBold30 = _nunitoWith(TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white));
  static TextStyle extraBold48 = _nunitoWith(TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white));
  static TextStyle extraBold24 = _nunitoWith(TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white));
}

TextStyle _nunitoWith(TextStyle textStyle) => GoogleFonts.nunito(textStyle: textStyle);