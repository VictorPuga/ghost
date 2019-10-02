part of models;

class Credentials extends BaseModel {
  final String accessToken;
  final String tokenType;
  final int expirationDate;
  final String refreshToken;
  final int refreshExpirationDate;
  final String membershipId;

  Credentials({
    @required this.accessToken,
    @required this.tokenType,
    @required this.expirationDate,
    @required this.refreshToken,
    @required this.refreshExpirationDate,
    @required this.membershipId,
  })  : assert(accessToken != null),
        assert(tokenType != null),
        assert(expirationDate != null),
        assert(refreshToken != null),
        assert(refreshExpirationDate != null),
        assert(membershipId != null);

  factory Credentials.fromJson(Map<String, dynamic> credentials) => Credentials(
        accessToken: credentials['accessToken'],
        tokenType: credentials['tokenType'],
        expirationDate: credentials['expirationDate'],
        refreshToken: credentials['refreshToken'],
        refreshExpirationDate: credentials['refreshExpirationDate'],
        membershipId: credentials['membershipId'],
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'tokenType': tokenType,
        'expirationDate': expirationDate,
        'refreshToken': refreshToken,
        'refreshExpirationDate': refreshExpirationDate,
        'membershipId': membershipId,
      };

  bool get accessTokenExpired =>
      DateTime.now().millisecondsSinceEpoch > expirationDate;

  bool get refreshTokenExpired =>
      DateTime.now().millisecondsSinceEpoch > expirationDate;

  bool get accessTokenIsActive => !accessTokenExpired;

  bool get refreshTokenIsActive => !refreshTokenExpired;
}
