import 'package:gsheets/gsheets.dart';

import 'user.dart';

class UserSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "",
  "private_key_id": "",
  "private_key": "-----BEGIN PRIVATE KEY-----\n\n-----END PRIVATE KEY-----\n",
  "client_email": "",
  "client_id": "",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/sristi-tshirt-editor%40sristi-bill-checker.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
  static const String _sheetId = '';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;
  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_sheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'Bills');
    } catch (e) {
      print("Init Error : $e");
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<void> updateTshirt(int? billNo, bool tshirtRecieved) async {
    if (billNo == null) return;
    await _userSheet!.values.insertValueByKeys(tshirtRecieved,
        columnKey: UserFields.tshirtRecieved, rowKey: billNo);
  }

  static Future<void> updateID(int? billNo, bool idRecieved) async {
    if (billNo == null) return;
    await _userSheet!.values.insertValueByKeys(idRecieved,
        columnKey: UserFields.idRecieved, rowKey: billNo);
  }

  static Future<User?> getByBill(int? billNo) async {
    if (billNo == null) return null;
    if (_userSheet == null) return null;
    final json = await _userSheet!.values.map.rowByKey(billNo);
    if (json == null) return null;
    return User.fromJson(json);
  }
}
