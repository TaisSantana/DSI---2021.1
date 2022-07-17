import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de nomes Taís',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final favoritos = <WordPair>{};
  final fonte = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: const Text('Gerador de nomes Taís'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _pushSaved,
            tooltip: 'Mostrar Favoritos',
          ),
        ],
      ),               
      body: ListView.builder( 
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider(); /*2*/
          
          final index = i ~/ 2; 
          //Se chegar no fim da lista, gerar mais 10 palavras e colocar na lista.
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          final jaFoiFavoritado = favoritos.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: fonte,
            ),
            trailing: Icon(   
              jaFoiFavoritado ? Icons.favorite : Icons.favorite_border,
              color: jaFoiFavoritado ? Colors.lightBlue : null,
              semanticLabel: jaFoiFavoritado ? 'Remover favorito' : 'Favoritar',
            ),
            onTap: () {        
              setState(() {
                if (jaFoiFavoritado) {
                  favoritos.remove(_suggestions[index]);
                } else {
                  favoritos.add(_suggestions[index]);
                }
              });
            },         
          );
        },
      ),
    );
  }

  void _pushSaved() {
     Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = favoritos.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: fonte,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Lista de Favoritos'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

}
