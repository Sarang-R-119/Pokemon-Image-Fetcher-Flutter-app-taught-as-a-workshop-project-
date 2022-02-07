class Pokemon {
  String name;
  String imageUrl;

  Pokemon({required this.name, required this.imageUrl});

  factory Pokemon.fromJson(String pokemonName, Map<String, dynamic> json) {
    return Pokemon(
        name: pokemonName,
        imageUrl: json['sprites']['other']['official-artwork']
            ['front_default']);
  }
}
