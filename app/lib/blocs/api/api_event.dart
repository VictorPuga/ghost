import 'package:bungie_api/enums/destiny_component_type_enum.dart';
import 'package:bungie_api/models/group_user_info_card.dart';
import 'package:bungie_api/models/user_info_card.dart';
import 'package:equatable/equatable.dart';
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
  @override
  String toString() => 'GetUser';
}

class GetProfile extends APIEvent {
  final GroupUserInfoCard card;
  final List<int> components;

  GetProfile({
    @required this.card,
    this.components = const [DestinyComponentType.Characters],
  }) : super([card, components]);

  @override
  String toString() => '''GetProfile {
    card: $card,
    components: $components,
  }''';
}

class GetCharacters extends APIEvent {
  final GroupUserInfoCard card;

  GetCharacters({
    @required this.card,
  }) : super([card]);

  @override
  String toString() => '''GetCharacters {
        card: $card,
      }''';
}

class GetCharacter extends APIEvent {
  final GroupUserInfoCard card;
  final String characterId;

  final Sorting sortBy;
  // final Order orderBy;

  GetCharacter({
    @required this.card,
    @required this.characterId,
    @required this.sortBy,
    // this.orderBy,
  })  : assert(sortBy != null),
        super([
          card,
          characterId,
          sortBy,
          // orderBy,
        ]);

  @override
  String toString() => '''GetCharacter {
    card: $card,
    characterId: $characterId,
    sortBy: $sortBy,
  }''';
}

class EquipItem extends APIEvent {
  final String id;
  final String characterId;
  final int membershipType;

  EquipItem({
    @required this.id,
    @required this.characterId,
    @required this.membershipType,
  }) : super([id, characterId, membershipType]);

  @override
  String toString() => '''EquipItem {
    id: $id,
    characterId: $characterId,
    membershipType: $membershipType,
  }''';
}

class GetSets extends APIEvent {
  final GroupUserInfoCard card;

  GetSets({
    @required this.card,
  }) : super([card]);

  @override
  String toString() => '''GetSets {
      card: $card,
    }''';
}

class GetAllItems extends APIEvent {
  final GroupUserInfoCard card;
  final int bucketHash;
  final Order orderBy;
  final String characterId;
  final int statHash;
  final int classCategoryHash;

  GetAllItems({
    @required this.card,
    @required this.bucketHash,
    this.characterId,
    this.orderBy = Order.defaultOrder,
    this.statHash,
    this.classCategoryHash,
  })  : assert(bucketHash != null),
        assert(orderBy != null),
        super([
          card,
          bucketHash,
          orderBy,
          characterId,
        ]);

  @override
  String toString() => '''GetAllItems {
    card: $card,
    bucketHash: $bucketHash,
    orderBy: $orderBy,
    characterId: $characterId,
  }''';
}

class RefreshToken extends APIEvent {
  final String token;

  RefreshToken({@required this.token}) : super([token]);

  @override
  String toString() => 'RefreshToken { token: $token }';
}
