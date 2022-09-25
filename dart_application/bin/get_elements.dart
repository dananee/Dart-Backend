import 'dart:html';
import 'server.dart';

String tagname() {
  var p = html.readAsBytes().then((value) => value.getElementsByTagName('p'));
  
}
