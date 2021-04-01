class StatusModel {
  int? id;
  String? name;
  String? emoji;
  String? emojiU;
  List<State> state;

  StatusModel({
    this.id,
    this.name,
    this.emoji,
    this.emojiU,
    this.state = const [],
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    final state = <State>[];
    if (json['state'] != null) {
      json['state'].forEach((v) {
        state.add(new State.fromJson(v));
      });
    }
    return StatusModel(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
      emojiU: json['emojiU'],
      state: state,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emoji'] = this.emoji;
    data['emojiU'] = this.emojiU;
    data['state'] = this.state.map((v) => v.toJson()).toList();
    return data;
  }
}

class State {
  int? id;
  String? name;
  int? countryId;
  List<City> city;

  State({
    this.id,
    this.name,
    this.countryId,
    this.city = const [],
  });

  factory State.fromJson(Map<String, dynamic> json) {
    final city = <City>[];
    if (json['city'] != null) {
      json['city'].forEach((v) {
        city.add(new City.fromJson(v));
      });
    }
    return State(
      id: json['id'],
      name: json['name'],
      countryId: json['country_id'],
      city: city,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    data['city'] = this.city.map((v) => v.toJson()).toList();
    return data;
  }
}

class City {
  int? id;
  String? name;
  int? stateId;

  City({
    this.id,
    this.name,
    this.stateId,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    return data;
  }
}
