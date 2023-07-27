import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'articulos.dart';
import 'common.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url:"https://qpewttmefqniyqflyjmu.supabase.co" ,anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFwZXd0dG1lZnFuaXlxZmx5am11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzM2NjI1NDYsImV4cCI6MTk4OTIzODU0Nn0.OnRuoILFCh1WhCTjNx8JGRPaf_OzrBthdhL-H3dXhQk" );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Articulos> articulos = [];
  bool borrar = false;
  @override
  void initState() {
    super.initState();
    if (!borrar){
       limpiarganador();
       borrar=true;
    }
    getWebSiteData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WebScraping'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: articulos.length,
          itemBuilder: (context, index) {
            final articulo = articulos[index];
            var xHora =  articulo.hora.substring(0,4);
            var xOper =  articulo.hora.substring(5,articulo.hora.length);
            return Expanded(
              child: ListTile(
                leading: Image.network('https://lotoven.com/${articulo.urlimage}',height: 100,width: 100,),
                title: Text(articulo.nombre,
                    style:const TextStyle(fontSize: 26)),
                subtitle:  Text(
                    '${articulo.numero} Hora:${xHora} $xOper',style:const TextStyle(fontSize: 16)),
              ),
            );
          },
        ));
  }

  Future getWebSiteData() async {
//    final url = Uri.parse('https://www.amazon.com/s?k=iphone');

    final url = Uri.parse(
        'https://lotoven.com/animalitos/');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final numero = html
          .querySelectorAll('h4 > small')
          .map((element) => element.innerHtml.trim())
          .toList();
      final nombre = html
          .querySelectorAll(' > span.info')
          .map((element) => element.innerHtml.trim())
          .toList();
      final hora = html
          .querySelectorAll(' div > span.info2')
          .map((element) => element.innerHtml.trim())
          .toList();

      final urlimage = html
          .querySelectorAll(' > div > div > img')
          .map((element) => element.attributes['src']!)
          .toList();
      urlimage.remove('/assets/images/investment/thumb-min.webp');
      print (urlimage.length);
      setState(() {
        articulos = List.generate(nombre.length,
                (index) => Articulos(
                  operador: hora[index].substring(5,hora[index].length),
                  numero:'',
                  urlimage: urlimage[index],
                  nombre: nombre[index],
                  hora:hora[index],));
        var contx = articulos.length+1;
        for (var index = 0; index < contx; index++) {
        var xgan = articulos[index];
        String xoper = xgan.operador;
        String xnumero = xgan.numero;
        String xima = xgan.urlimage;
        String xnomb = xgan.nombre;
        String xhora = xgan.hora;

        insertarGanador(xoper,xnumero,xima,xnomb,xhora);
        }
      });

    }catch (e){
      if (kDebugMode) {
        // ignore: prefer_interpolation_to_compose_strings
        print('{eeee$e}');
      }
    }

// #article-content-container > h3:nth-child(306)
//       .querySelectorAll('h2 > a > span')
  }

  insertarGanador(xoper,xnumero,xima,xnomb,xhora)async{

    try{
      await cliente
          .from('loterias')
          .insert({'operador':xoper,'numero': xnumero,  'nombre':xnomb,
        'urlimage':xima,
       'hora':xhora});
    }catch (e) {
      print(e);
    }

  }
  limpiarganador() async {
    await cliente.from('loterias').delete().gte('id',0);
  }
}
