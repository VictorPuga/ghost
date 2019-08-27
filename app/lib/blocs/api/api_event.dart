import 'package:equatable/equatable.dart';
import 'package:ghost/models/models.dart';
import 'package:meta/meta.dart';

import 'package:ghost/utils.dart';

abstract class APIEvent extends Equatable {
  APIEvent([List props = const []]) : super(props);
}

class ThrowAPIError extends APIEvent {
  final String error;
  final StackTrace stackTrace;
  ThrowAPIError(this.error, [this.stackTrace]);

  @override
  String toString() => '''
      ThrowAPIError {
        error: $error,
        stackTrace: $stackTrace 
      }
      ''';
}

class ReceiveCredentials extends APIEvent {
  final String responseJson;
  ReceiveCredentials({@required this.responseJson}) : super([responseJson]);

  @override
  String toString() => '''ReceiveCredentials {
        responseJson: ${responseJson.substring(0, 40)}... 
      }''';
}

class GetUser extends APIEvent {
  final String membershipId;
  GetUser({@required this.membershipId}) : super([membershipId]);

  @override
  String toString() => 'GetUser { membershipId: $membershipId}';
}

class GetMembership extends APIEvent {
  final String accessToken;
  GetMembership({@required this.accessToken}) : super([accessToken]);

  @override
  String toString() =>
      'GetUser { accessToken: ${accessToken.substring(0, 40)}... }';
}

class GetProfile extends APIEvent {
  final UserInfoCard card;
  final String accessToken;
  final List<int> components;

  GetProfile({
    @required this.card,
    @required this.accessToken,
    this.components = const [DestinyComponentType.characters],
  }) : super([card, accessToken, components]);

  @override
  String toString() =>
      'GetProfile { card: $card, components: $components, accessToken: ${accessToken.substring(0, 40)}... }';
}

class GetCharacters extends APIEvent {
  final UserInfoCard card;
  final String accessToken;

  GetCharacters({
    @required this.card,
    @required this.accessToken,
  }) : super([card, accessToken]);

  @override
  String toString() => '''GetCharacters {
        card: $card,
        accessToken: ${accessToken.substring(0, 40)}... 
      }''';
}

class GetCharacter extends APIEvent {
  final UserInfoCard card;
  final String characterId;
  final String accessToken;
  final Sorting sortBy;
  // final Order orderBy;

  GetCharacter({
    @required this.card,
    @required this.characterId,
    @required this.accessToken,
    @required this.sortBy,
    // this.orderBy,
  })  : assert(sortBy != null),
        super([
          card,
          characterId,
          accessToken,
          sortBy,
          // orderBy,
        ]);

  @override
  String toString() => '''GetCharacter {
    card: $card,
    characterId: $characterId,
    accessToken: $accessToken,
    sortBy: $sortBy,
  }''';
}

class EquipItem extends APIEvent {
  final String id;
  final String characterId;
  final int membershipType;
  final String accessToken;

  EquipItem({
    @required this.id,
    @required this.characterId,
    @required this.membershipType,
    @required this.accessToken,
  }) : super([id, characterId, membershipType, accessToken]);

  @override
  String toString() => '''EquipItem {
    id: $id,
    characterId: $characterId,
    membershipType: $membershipType,
    accessToken: $accessToken,
  }''';
}

class GetAllItems extends APIEvent {
  final UserInfoCard card;
  final String accessToken;
  final int bucketHash;
  final Order orderBy;

  GetAllItems({
    @required this.card,
    @required this.accessToken,
    @required this.bucketHash,
    this.orderBy = Order.defaultOrder,
  })  : assert(bucketHash != null),
        assert(orderBy != null),
        super([
          card,
          accessToken,
          bucketHash,
          orderBy,
        ]);

  @override
  String toString() => '''GetAllItems {
    card: $card,
    accessToken: ${accessToken.substring(0, 40)}... 
    bucketHash: $bucketHash,
    orderBy: $orderBy,
  }''';
}
// class RefreshToken extends APIEvent {
//   final String token;
//   RefreshToken({@required this.token}) : super([token]);

//   @override
//   String toString() => 'RefreshToken { token: $token }';
// }
