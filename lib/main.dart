import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:graphql/client.dart';
import 'package:graphql_and_html/graphql.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String htmlInput = '''''';

  void performGraphQL() async {
    final HttpLink httpLink = HttpLink('${dotenv.env['API']}/graphql');

    final GraphQLClient client = GraphQLClient(
      /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: httpLink,
    );

    const int nRepositories = 50;
    final QueryOptions options = QueryOptions(
      document: gql(GraphQLQuery.getPosts),
      variables: <String, dynamic>{'nRepositories': nRepositories},
    );

    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    }

    print(result.data?['posts']['edges'][0]);
    setState(() {
      // htmlInput = result.data.toString();
      htmlInput = '''
${result.data?['posts']['edges'][0]['node']['title'].toString() ?? ''}
${result.data?['posts']['edges'][0]['node']['content'].toString() ?? ''}

''';
    });
  }

  @override
  void didChangeDependencies() {
    performGraphQL();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    performGraphQL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HtmlWidget(htmlInput),
            ],
          ),
        ),
      ),
    );
  }
}
