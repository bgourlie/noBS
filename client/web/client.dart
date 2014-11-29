import 'dart:html';
import 'package:intl/intl.dart';
const VERSION = 'alpha';
const BUILD_NUMBER = '';
const BRANCH = '';
const COMMIT_ID = '';
const BUILD_TIME = '';

void main() {
  final buildTime = DateTime.parse(BUILD_TIME);
  final formatter = new DateFormat.yMd().add_Hm();
  querySelector('#version')
    ..text = '$VERSION build $BUILD_NUMBER ${formatter.format(buildTime.toLocal())}';

  querySelector('#sample_text_id')
    ..text = 'Click me!'
    ..onClick.listen(reverseText);
}

void reverseText(MouseEvent event) {
  var text = querySelector('#sample_text_id').text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  querySelector('#sample_text_id').text = buffer.toString();
}
