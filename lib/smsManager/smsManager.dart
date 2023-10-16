import 'package:flutter_sms/flutter_sms.dart';

class smsManager {

  void sendSMSManager(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

}