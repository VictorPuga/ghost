part of models;

class Credentials extends Destiny2Model {
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

class GeneralUser extends Destiny2Model {
  final String membershipId; // docs say int64
  final String uniqueName;
  final String normalizedName;
  final String displayName;
  final int profilePicture;
  final int profileTheme;
  final int userTitle;
  final String successMessageFlags; // docs say int64
  final bool isDeleted;
  final String about;
  final DateTime firstAccess;
  final DateTime lastUpdate;
  final int legacyPortalUID;
  final context; // UserToUserContext
  final String psnDisplayName;
  final String xboxDisplayName;
  final String fbDisplayName;
  final bool showActivity;
  final String locale;
  final bool localeInheritDefault;
  final int lastBanReportId;
  final bool showGroupMessaging;
  final String profilePicturePath;
  final String profileThemeName;
  final String userTitleDisplay;
  final String statusText;
  final DateTime statusDate;
  final DateTime profileBanExpire;
  final String blizzardDisplayName;

  GeneralUser({
    @required this.membershipId,
    @required this.uniqueName,
    this.normalizedName,
    @required this.displayName,
    @required this.profilePicture,
    @required this.profileTheme,
    @required this.userTitle,
    @required this.successMessageFlags,
    @required this.isDeleted,
    @required this.about,
    this.firstAccess,
    this.lastUpdate,
    this.legacyPortalUID,
    this.context,
    this.psnDisplayName,
    this.xboxDisplayName,
    this.fbDisplayName,
    this.showActivity,
    @required this.locale,
    @required this.localeInheritDefault,
    this.lastBanReportId,
    @required this.showGroupMessaging,
    @required this.profilePicturePath,
    @required this.profileThemeName,
    @required this.userTitleDisplay,
    @required this.statusText,
    @required this.statusDate,
    this.profileBanExpire,
    this.blizzardDisplayName,
  })  : assert(membershipId != null),
        assert(uniqueName != null),
        // assert(normalizedName != null),
        assert(displayName != null),
        assert(profilePicture != null),
        assert(profileTheme != null),
        assert(userTitle != null),
        assert(successMessageFlags != null),
        assert(isDeleted != null),
        assert(about != null),
        // assert(psnDisplayName != null),
        // assert(xboxDisplayName != null),
        // assert(blizzardDisplayName != null)
        assert(locale != null),
        assert(localeInheritDefault != null),
        assert(showGroupMessaging != null),
        assert(profilePicturePath != null),
        assert(profileThemeName != null),
        assert(userTitleDisplay != null),
        assert(statusText != null),
        assert(statusDate != null),
        super([
          membershipId,
          uniqueName,
          normalizedName,
          displayName,
          profilePicture,
          profileTheme,
          userTitle,
          successMessageFlags,
          isDeleted,
          about,
          firstAccess,
          lastUpdate,
          legacyPortalUID,
          psnDisplayName,
          xboxDisplayName,
          fbDisplayName,
          showActivity,
          locale,
          localeInheritDefault,
          lastBanReportId,
          showGroupMessaging,
          profilePicturePath,
          profileThemeName,
          userTitleDisplay,
          statusText,
          statusDate,
          profileBanExpire,
          blizzardDisplayName,
        ]);

  factory GeneralUser.fromJson(Map<String, dynamic> res) => GeneralUser(
        membershipId: res['membershipId'],
        uniqueName: res['uniqueName'],
        normalizedName: res['normalizedName'],
        displayName: res['displayName'],
        profilePicture: res['profilePicture'],
        profileTheme: res['profileTheme'],
        userTitle: res['userTitle'],
        successMessageFlags: res['successMessageFlags'],
        isDeleted: res['isDeleted'],
        about: res['about'],
        firstAccess: DateTime.tryParse(res['firstAccess']),
        lastUpdate: DateTime.tryParse(res['lastUpdate']),
        legacyPortalUID: res['legacyPortalUID'],
        context: res['context'],
        psnDisplayName: res['psnDisplayName'],
        xboxDisplayName: res['xboxDisplayName'],
        fbDisplayName: res['fbDisplayName'],
        showActivity: res['showActivity'],
        locale: res['locale'],
        localeInheritDefault: res['localeInheritDefault'],
        lastBanReportId: res['lastBanReportId'],
        showGroupMessaging: res['showGroupMessaging'],
        profilePicturePath: res['profilePicturePath'],
        profileThemeName: res['profileThemeName'],
        userTitleDisplay: res['userTitleDisplay'],
        statusText: res['statusText'],
        statusDate: DateTime.tryParse(res['statusDate']),
        profileBanExpire: res['profileBanExpire'] != null
            ? DateTime.tryParse(res['profileBanExpire'])
            : null,
        blizzardDisplayName: res['blizzardDisplayName'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'membershipId': membershipId,
        'uniqueName': uniqueName,
        'normalizedName': normalizedName,
        'displayName': displayName,
        'profilePicture': profilePicture,
        'profileTheme': profileTheme,
        'userTitle': userTitle,
        'successMessageFlags': successMessageFlags,
        'isDeleted': isDeleted,
        'about': about,
        'firstAccess': firstAccess.toIso8601String(),
        'lastUpdate': lastUpdate.toIso8601String(),
        'legacyPortalUID': legacyPortalUID,
        'context': context,
        'psnDisplayName': psnDisplayName,
        'xboxDisplayName': xboxDisplayName,
        'fbDisplayName': fbDisplayName,
        'showActivity': showActivity,
        'locale': locale,
        'localeInheritDefault': localeInheritDefault,
        'lastBanReportId': lastBanReportId,
        'showGroupMessaging': showGroupMessaging,
        'profilePicturePath': profilePicturePath,
        'profileThemeName': profileThemeName,
        'userTitleDisplay': userTitleDisplay,
        'statusText': statusText,
        'statusDate': statusDate.toIso8601String(),
        'profileBanExpire': profileBanExpire?.toIso8601String(),
        'blizzardDisplayName': blizzardDisplayName,
      };
}

class UserInfoCard extends Destiny2Model {
  final String iconPath;
  final String displayName;
  final int membershipType;
  final String membershipId;
  final String supplementalDisplayName;
  UserInfoCard({
    @required this.iconPath,
    @required this.displayName,
    @required this.membershipType,
    @required this.membershipId,
    this.supplementalDisplayName,
  })  : assert(iconPath != null),
        assert(displayName != null),
        assert(membershipType != null),
        assert(membershipId != null),
        super([
          iconPath,
          displayName,
          membershipType,
          membershipId,
          supplementalDisplayName,
        ]);

  factory UserInfoCard.fromJson(Map<String, dynamic> res) => UserInfoCard(
        iconPath: res['iconPath'],
        displayName: res['displayName'],
        membershipType: res['membershipType'],
        membershipId: res['membershipId'],
        supplementalDisplayName: res['supplementalDisplayName'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'iconPath': iconPath,
        'displayName': displayName,
        'membershipType': membershipType,
        'membershipId': membershipId,
        'supplementalDisplayName': supplementalDisplayName,
      };
}

class UserMembershipData extends Destiny2Model {
  final List<UserInfoCard> destinyMemberships;
  final GeneralUser bungieNetUser;

  UserMembershipData({
    @required this.destinyMemberships,
    @required this.bungieNetUser,
  })  : assert(destinyMemberships != null),
        assert(bungieNetUser != null),
        super([destinyMemberships, bungieNetUser]);

  factory UserMembershipData.fromJson(Map<String, dynamic> res) {
    // TODO: Implement logic for user to select which membership to use
    List<UserInfoCard> memberships = [];
    res['destinyMemberships'].forEach(
      (membership) => memberships.add(
            UserInfoCard.fromJson(membership),
          ),
    );

    return UserMembershipData(
      destinyMemberships: memberships,
      bungieNetUser: GeneralUser.fromJson(res['bungieNetUser']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'destinyMemberships': destinyMemberships,
        'bungieNetUser': bungieNetUser,
      };

  int get membershipCount => destinyMemberships.length;

  bool get hasMultipleMemberships => membershipCount > 1;
}
