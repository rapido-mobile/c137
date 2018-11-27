import 'package:flutter/material.dart';
import 'package:rapido/documents.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'get_remote_json.dart';
import 'character_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C-137',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'C-137'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // create a DocumentList for storing results. This will make it much
  // easier to manage the list view by using a DocumentListView, but will
  // also automatically persist the search results, so that when users reopen
  // the app, their last set of results will be there
  DocumentList _documentList = DocumentList("c137Results");

  // Store the search bar and search term in an accessible place
  SearchBar _searchBar;
  String _searchTerm = "Search";

  // create 3 widgets to use depending depending on the state of the searching
  Widget _initialWidget = Center(child: Text("What is my purpose?"));
  Widget _busyWidget = Center(child: CircularProgressIndicator());
  Widget _emptyResultsWidget = Center(
      child: Text("No Results",
          style: TextStyle(fontSize: 50.0, color: Colors.red)));

  // store a variable for the empty list widget
  Widget _currentEmptyListWidget;

  _MyHomePageState() {
    _currentEmptyListWidget = _initialWidget;

    // build the search bar using flutter_search_bar
    // https://pub.dartlang.org/packages/flutter_search_bar
    _searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: (BuildContext context) {
          return new AppBar(
              title: new Text(_searchTerm),
              actions: [_searchBar.getSearchAction(context)]);
        },
        setState: setState,
        onSubmitted: onSubmitted,
        onClosed: () {
          print("closed");
        });
  }

  // A term has been entered, let's do the search
  void onSubmitted(String value) async {

    // call clear() to remove the old search results
    // this will result in an empty list
    _documentList.clear();

    // call set state to set the emptyListWidget to the _busyWidget
    // and set the search term to the value passed in
    setState(() {
      _currentEmptyListWidget = _busyWidget;
      _searchTerm = value;
    });

    // create the url string
    String url = "https://rickandmortyapi.com/api/character/?name=$value";

    // fetch the json use the retreived data
    // getAndUseRemoteJson is a helper function that returns a
    // future. You can either call it with await in order to block
    // or use then, to not block, but then to process the data
    // when it arrives, like in this example
    getAndUseRemoteJSon(url).then((dynamic map) {
      List<dynamic> resultList = map["results"];

      // in the case where the return results are null (usually because
      // no results were returned), we set the _emptyListWidget to display
      // that there were no results
      if (resultList == null) {
        setState(() {
          _currentEmptyListWidget = _emptyResultsWidget;
        });
      } else {
        // if there were results, we process them with the helper function
        // which creates a Document from each result which gets added to the
        // DocumentList which is displayed in the DocumentListView
        resultList.forEach((dynamic item) {
          _documentList.add(_docFromMap(item));
        });
      }
    });
  }

  Document _docFromMap(Map<String, dynamic> map) {
    // extract the location, which is another map
    Map<String, dynamic> locOb = map["location"];

    // extract the name of the location (or leave it as null)
    String location;
    if (locOb != null) {
      location = locOb["name"];
    }
    // Create the Document with the desired values
    return Document(
      initialValues: {
        "name": map["name"],
        "Status": map["status"],
        "Species": map["species"],
        "Gender": map["gender"],
        "image": map["image"],
        "Origin": map["origin"],
        "Last Location": location,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchBar.build(context),
      ),
      body: Container(
        child: DocumentListView(
          _documentList,
          emptyListWidget: _currentEmptyListWidget,
          customItemBuilder: characterCard,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.png"),
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(.4), BlendMode.dstATop)),
        ),
      ),
    );
  }
}
