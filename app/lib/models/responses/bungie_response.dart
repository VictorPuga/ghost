part of models;

class BungieResponse // <M extends Destiny2Model>
    extends Destiny2Model {
  // final M data;
  final dynamic data; // Map || int
  final int errorCode;
  final int throttleSeconds;
  final String errorStatus;
  final String message;
  final Map messageData;
  final String detailedErrorTrace;

  BungieResponse({
    @required this.data,
    @required this.errorCode,
    @required this.throttleSeconds,
    @required this.errorStatus,
    @required this.message,
    @required this.messageData,
    this.detailedErrorTrace,
  })  :
        // assert(data != null),
        assert(errorCode != null),
        assert(throttleSeconds != null),
        assert(errorStatus != null),
        assert(message != null),
        assert(messageData != null);

  factory BungieResponse.fromJson(Map<String, dynamic> res) {
    // M res;
    // switch (M.runtimeType.toString()) {
    //   case 'SomeModel':
    //     res = SomeModel(res) as M;
    //     break;
    //   default:
    // }
    return BungieResponse(
      // data: res,
      data: res['Response'],
      errorCode: res['ErrorCode'],
      throttleSeconds: res['ThrottleSeconds'],
      errorStatus: res['ErrorStatus'],
      message: res['Message'],
      messageData: res['MessageData'],
      detailedErrorTrace: res['DetailedErrorTrace'],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'errorCode': errorCode,
        'throttleSeconds': throttleSeconds,
        'errorStatus': errorStatus,
        'message': message,
        'messageData': messageData,
        'detailedErrorTrace': detailedErrorTrace
      };
}
