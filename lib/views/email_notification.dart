import 'dart:developer';

import 'package:mailer/mailer.dart';

import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String url) async {
  try {
    var userEmail = 'crimereporting@gmail.com';
    var message = Message();
    message.subject = 'From Crime Reporting Together';
    message.text = 'A new video has been uploaded /n $url';
    message.from = Address(userEmail.toString());
    message.recipients.add('sharn.sappleton@gmail.com');

    var smtpServer = gmailSaslXoauth2(userEmail, "must use a token");
    send(message, smtpServer);
  } catch (e) {
    log(e.toString());
  }
}
