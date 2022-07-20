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
  bool ehCard = false;

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
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: (){
              setState(() {
                ehCard = !ehCard;
              });
            },
            tooltip: 'Mudar Layout',
          ),
          
        ],
      ),
      body: ehCard ? formatoCards() : formatoLista()
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
  
  Widget formatoLista() {
    return ListView.builder( 
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider(); /*2*/
        
        final index = i ~/ 2; 
        //Se chegar no fim da lista, gerar mais 10 palavras e colocar na lista.
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        
        return configuracaoFavoritos(_suggestions[index]);
      },
    );
  }

  Widget formatoCards() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 2,mainAxisExtent: 100.0),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return Card(
          child: configuracaoFavoritos(_suggestions[i]),
        );
      },
    );
  }

 //settado para cada palavra
  Widget configuracaoFavoritos(WordPair pair) {

    final jaFoiFavoritado = favoritos.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: fonte,
      ),
      trailing:IconButton(
            icon: 
              Icon(     
                jaFoiFavoritado ? Icons.favorite : Icons.favorite_border,
              ),
            color: jaFoiFavoritado ? Colors.lightBlue : null,
            onPressed: () {
              setState(() {
                jaFoiFavoritado ? favoritos.remove(pair) : favoritos.add(pair);
              });
            },
            tooltip: jaFoiFavoritado ? 'Remover favorito' : 'Favoritar',
          ),           
    );
  }
}