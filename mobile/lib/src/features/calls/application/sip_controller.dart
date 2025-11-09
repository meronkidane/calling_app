import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sip_ua/flutter_sip_ua.dart';
import 'package:logging/logging.dart';

final sipControllerProvider =
    Provider<SipController>((ref) => SipController(SIPUAHelper()));

class SipController {
  SipController(this._helper);

  final SIPUAHelper _helper;
  final _log = Logger('SipController');

  RegistrationState? registrationState;
  CallStateEnum callState = CallStateEnum.NONE;

  Future<void> register({
    required String domain,
    required String user,
    required String password,
  }) async {
    final settings = UaSettings()
      ..webSocketUrl = 'wss://$domain:443'
      ..authorizationUser = user
      ..password = password
      ..displayName = user
      ..userAgent = 'CallingApp/0.1.0'
      ..contactUri = 'sip:$user@$domain';
    await _helper.start(settings);
  }

  Future<void> makeCall(String target) async {
    await _helper.call(target, false);
  }
}
