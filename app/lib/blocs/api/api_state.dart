import 'package:equatable/equatable.dart';
import 'package:ghost/models/models.dart';

abstract class APIState extends Equatable {
  APIState([List props = const []]) : super(props);
  get error => null;
  get hasError => error != null;
}

class InitialAPIState extends APIState {}

class APIError extends APIState {
  final String error;
  final StackTrace stacktrace;
  APIError({this.error, this.stacktrace}) : super([error, stacktrace]);

  @override
  String toString() => '''APIError {
    error: $error,
    trace: $stacktrace,
  }''';
}

class APILoading<S extends APIState> extends APIState {
  final S prevState;
  final error;
  APILoading({this.prevState, this.error}) : super([prevState, error]);

  @override
  String toString() => '''APILoading {
    prevState: $prevState,
    error: $error,
  }''';
}

class APICredentials extends APIState {
  final Credentials credentials;
  final UserMembershipData membershipData;
  final error;
  APICredentials(this.credentials, this.membershipData, {this.error})
      : super([credentials, error]);

  @override
  String toString() => '''APICredentials { 
      credentials: ${credentials.toString().substring(0, 40)}..., 
      membershipData: $membershipData,
      error: $error,
    }''';
}

class APIProfile extends APIState {
  final DestinyProfileResponse profileResponse;
  final error;
  APIProfile(this.profileResponse, {this.error})
      : super([profileResponse, error]);

  @override
  String toString() => '''APIProfile {
      profileResponse: ${profileResponse.toString()}
      error: $error,
    }''';
}

class APICharacters extends APIState {
  final List<Character> characters;
  final error;
  APICharacters(this.characters, {this.error}) : super([characters, error]);

  @override
  String toString() => '''APICharacters {
      characters: ${characters.toString()}
      error: $error,
    }''';
}

class APICharacter extends APIState {
  final Character character;
  final List<Item> inventory;
  final List<Item> equipment;

  final List<Item> items;
  final SortedItems sortedItems;
  final error;

  APICharacter({
    this.character,
    this.inventory,
    this.equipment,
    this.items,
    this.sortedItems,
    this.error,
  }) : super([
          character,
          inventory,
          equipment,
          items,
          sortedItems,
        ]);

  @override
  String toString() => '''APICharacter {
    character: $character,
    inventory: $inventory,
    equipment: $equipment,
    items: $items,
    sortedItems: $sortedItems,
    error: $error,
  }''';
}

class APIAllItems extends APIState {
  final SortedItems<Character> sortedItems;

  APIAllItems({this.sortedItems}) : super([sortedItems]);

  @override
  String toString() => '''APIAllItems {
    sortedItems: ${sortedItems.toJsonString()},
  }''';
}
