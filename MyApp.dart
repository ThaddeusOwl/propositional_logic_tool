/// Authors: Ahmed Ghoor, Mthokozeleni Sithole, Ahmed Khan
/// CSC3003S Capstone Project: TT4SPL
/// 6 October 2021

import 'package:flutter/material.dart';
import 'TruthTableGenerator.dart';
import 'LogicCheck.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truth Generator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Truth Table Generator Home'),
    );
  }
}

//Home Page

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Radio states
enum PCE { Sentence, Conclusion, Entails }
enum Property { Equivalence, Consistency, Entailment, Validity, Default }

class _MyHomePageState extends State<MyHomePage> {
  String input = "";
  String initStr = "";
  String format =
      " Enter Sentence to generate a truth Table and check for Truth Functional Determinance ";
  bool isEditing = false;
  List<String> listTest = ["A or B"];
  List<String> inputList = [];
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  var outputColumn = [];
  List<List> outputRows = [[]];

  // messages

  String messageDefault = "";
  String message = "";

  PCE? _senState = PCE.Sentence;
  List<PCE> MetaData = [PCE.Sentence];

  Property? _property = Property.Default;

  void _propertyCheck(LogicCheck logicCheck) {
    switch (_property) {
      case Property.Validity:
        message = logicCheck.getValidityMessage();
        break;
      case Property.Entailment:
        message = logicCheck.getEntailMessage();
        break;
      case Property.Consistency:
        message = logicCheck.getConsistancyMessage();
        break;
      case Property.Equivalence:
        message = logicCheck.getEquivalenceMessage();
        break;
      default:
        message = logicCheck.getMessages();
    }
  }

  void _updatePropertyText() {
    setState(() {
      switch (_property) {
        case Property.Validity:
          format =
              " A set of Sentences as Premise (1,...,n) and a Conclusion C(1)";
          break;
        case Property.Entailment:
          format =
              " A set of Sentences as Knowledgebase (1,...,n) and entailment sentence E(1)";
          break;
        case Property.Consistency:
          format = " A set of Sentences (2,...n)";
          break;
        case Property.Equivalence:
          format = " A set of Sentences (2,...n)";
          break;
        default:
          format =
              " Enter Sentence to generate a truth Table and check for Truth Functional Determinance ";
      }
    });
  }

// Add input to list
  void _Add() {
    setState(() {
      //
      switch (_senState) {
        case PCE.Conclusion:
          MetaData.add(PCE.Conclusion);
          break;
        case PCE.Entails:
          MetaData.add(PCE.Entails);
          break;
        default:
          MetaData.add(PCE.Sentence);
      }

      listTest.add(myController.text);
      myController.clear();
    });
  }

// Delete from inputlist
  void _Delete(String s, PCE meta) {
    setState(() {
      if (listTest.contains(s)) {
        MetaData.remove(meta);
        listTest.remove(s);
        //listTest.join();
      }
    });
  }

// edit sentence
  void _editSen(String s, PCE meta) {
    setState(() {
      myController.text = s;
      _Delete(s, meta);
    });
  }

// clear input list
  void _Clear() {
    setState(() {
      listTest.clear();
      outputColumn.length = 0;
      MetaData.clear();
      message = "";
      myController.clear();
    });
  }

// Remove last character of string
  String removeLastCharacter(String str) {
    String result = "";
    if (str.length > 0) {
      result = str.substring(0, str.length - 3);
    }
    return result;
  }

  String listToString(List<String> list) {
    String string = "";
    for (int i = 0; i < listTest.length; i++) {
      string = string + listTest[i] + " ; ";
    }
    return removeLastCharacter(string);
  }

// And button functionality
  void _and() {
    setState(() {
      String operator = " and ";
      myController.text = myController.text + operator;
      //Places curse at the end
      myController.selection = TextSelection.fromPosition(
          TextPosition(offset: myController.text.length));
    });
  }

// Or button functionality
  void _or() {
    setState(() {
      String operator = " or ";
      myController.text = myController.text + operator;
      //Places curse at the end
      myController.selection = TextSelection.fromPosition(
          TextPosition(offset: myController.text.length));
    });
  }

// not button functionality
  void _not() {
    setState(() {
      String operator = " not ";
      myController.text = myController.text + operator;
      //Places curse at the end
      myController.selection = TextSelection.fromPosition(
          TextPosition(offset: myController.text.length));
    });
  }

// implies button functionality
  void _implies() {
    setState(() {
      String operator = " implies ";
      myController.text = myController.text + operator;
      //Places curse at the end
      myController.selection = TextSelection.fromPosition(
          TextPosition(offset: myController.text.length));
    });
  }

// Material equivalance button functionality
  void _mEquivalence() {
    setState(() {
      String operator = " equals ";
      myController.text = myController.text + operator;
      //Places curse at the end
      myController.selection = TextSelection.fromPosition(
          TextPosition(offset: myController.text.length));
    });
  }

  void _displayInput() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //input = myController.text;
      // Print metadata

      String stringInput = listToString(listTest);

      inputList = stringInput.split(" ");
      inputList.removeWhere((element) => element.isEmpty);
      print(inputList);

      TruthTableGenerator ttg = TruthTableGenerator(inputList);
      outputColumn = ttg.fullEquation.getAtoms();
      outputRows = ttg.getTruthTable();
      LogicCheck logicCheck = LogicCheck(outputRows, outputColumn.join(','),
          ttg.getNumEquations(), MetaData.toList());
      // Perform property check based on selected radiobox
      _propertyCheck(logicCheck);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    // Sentence state

    return MaterialApp(
      home: DefaultTabController(
        // The number of tabs / content sections to display.
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('TT4SPL'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('Help Page'),
                      ),
                      body: SingleChildScrollView(
                        child: Container(
                            child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'HOW TO USE THIS APP\n\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'This app is made up of two Tabs: a Truth Table generator, and a Logical Property checker, for sentences of propositional logic. These components can be selected by clicking on the respective Tab buttons at the top of the screen.\n\n' +
                                        'On either screen, the user is able to enter one or more sentences of propositional logic. A sentence can be entered by typing in the Textfield, and then pressing the "Add" button. There is a range of buttons for connectives "And", "Or", "Implies", "Equals", and "Negation" provided to assist the user with input. The input can also be typed manually.\n\n'),
                                TextSpan(
                                    text:
                                        "There must be at least one space character between every character of input: e.g. (A or B) should be: ( A or B )\n",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                                TextSpan(
                                    text:
                                        'The user must specify whether the given sentence is intended as a regular sentence, as a conlcusion, or as an entailment sentence using the radio buttons at the top of the screen. This must be done before pressing the "Add" button. The "Clear" button will remove all added sentences from the screen, result and truth table generated\n\n'),
                                TextSpan(
                                    text: 'TRUTH TABLE GENERATOR\n\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        'When a set of one or more sentences have been added, the user is able to generate the truth table for this set by clicking the "Run" button at the bottom of the Truth Table Generator Screen. The generated Truth Table will then be displayed on this screen. \n \n '),
                                TextSpan(
                                    text: 'LOGICAL PROPERTY CHECKER\n\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        'On the logical property check screen there are a further set of five radio buttons. For each radio button the app will operate as follows: \n\n'),
                                TextSpan(
                                    text: 'Default\n\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        'With the "Default" radio button selected the app will test whether each of the given sentences are truth-functionally true, truth-functionally false, or truth-functionally indeterninant.\n\n'),
                                TextSpan(
                                    text: 'Equivalence\n\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        'With the "Equivalence" radio button selected the app will test whether a set of 2 or more sentences of propositional logic are truth-functionally Equavalent to each other. This check requires at least 2 senteces be added.\n\n'),
                                TextSpan(
                                    text: 'Consistancy\n\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        'With the "Consistancy" radio button selected the app will test whether or not a given argument is truth-functionally Consistant. This check requires at least two sentences be added.\n\n'),
                                TextSpan(
                                    text: 'Validity\n\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        'With the "Validty" radio button selected the app will test whether a given argument is truth-functionally valid. An argument is made up of one or more set of sentences that form a Premise and 1 sentence designated as the conclusion. This check will require that at least one premise as well as a conlcusion.\n\n'),
                                TextSpan(
                                    text: 'Entailment\n\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        'With the "Entailment" radio button selected the app will test whether or not a set of sentences K is entailed by another sentence E. This check will require at least 1 sentence for the set of sentences K and an entailment sentence E. \n\n'),
                                TextSpan(
                                    text:
                                        'The selected logical check can be run by clicking the "Run button at the bottom of the logical property check screen.')
                              ]),
                        )),
                      ),
                    );
                  }));
                },
                icon: Icon(Icons.more_vert_outlined),
                tooltip: "Help Page",
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                    icon: Icon(Icons.table_chart),
                    text: "Truth Table Generator"),
                Tab(
                    icon: Icon(Icons.lightbulb),
                    text: "Logical Property Checker"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: ListTile(
                              title: Text("Sentence"),
                              leading: Radio<PCE>(
                                value: PCE.Sentence,
                                groupValue: _senState,
                                onChanged: (PCE? value) {
                                  setState(() {
                                    _senState = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: ListTile(
                              title: Text("Conclusion"),
                              leading: Radio<PCE>(
                                value: PCE.Conclusion,
                                groupValue: _senState,
                                onChanged: (PCE? value) {
                                  setState(() {
                                    _senState = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Flexible(
                              child: ListTile(
                            title: Text("Entails"),
                            leading: Radio<PCE>(
                              value: PCE.Entails,
                              groupValue: _senState,
                              onChanged: (PCE? value) {
                                setState(() {
                                  _senState = value;
                                });
                              },
                            ),
                          )),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width) - 60,
                          height: 40,
                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Formula',
                            ),
                            onSubmitted: (String s) {
                              setState(() {
                                myController.text = s;
                                //s = myController.text;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(5),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            onPressed: () {
                              _Add();
                            },
                          ),
                        )
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      buttonPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      children: [
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "And",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x039B),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _and();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "Or",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x56),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _or();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "Not",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x00AC),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _not();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "Implies",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x2192),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _implies();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "Equals",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x2194),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _mEquivalence();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              child: Text(
                                "Clear",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _Clear();
                              },
                            ))
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: listTest.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(listTest[index]),
                              subtitle: Text(
                                  (MetaData[index].toString()).substring(4)),
                              onTap: () {
                                _editSen(listTest[index], MetaData[index]);
                              },
                            ),
                          );
                        }),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (outputColumn.length > 0 &&
                              outputRows.length > 0 &&
                              outputColumn.length == outputRows[0].length)
                            DataTable(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.blueGrey.shade50,
                                        Colors.blue.shade100
                                      ]),
                                ),
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.blue.shade100),
                                columns: outputColumn
                                    .map((e) => DataColumn(
                                            label: Text(
                                          e.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )))
                                    .toList(),
                                rows: outputRows
                                    .map((e) => DataRow(cells: [
                                          for (var i = 0;
                                              i < outputColumn.length;
                                              i++)
                                            new DataCell(Text(e[i].toString()))
                                        ]))
                                    .toList()),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: ListTile(
                            title: Text("Sentence"),
                            leading: Radio<PCE>(
                              value: PCE.Sentence,
                              groupValue: _senState,
                              onChanged: (PCE? value) {
                                setState(() {
                                  _senState = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            title: Text("Conclusion"),
                            leading: Radio<PCE>(
                              value: PCE.Conclusion,
                              groupValue: _senState,
                              onChanged: (PCE? value) {
                                setState(() {
                                  _senState = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                            child: ListTile(
                          title: Text("Entails"),
                          leading: Radio<PCE>(
                            value: PCE.Entails,
                            groupValue: _senState,
                            onChanged: (PCE? value) {
                              setState(() {
                                _senState = value;
                              });
                            },
                          ),
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width) - 60,
                          height: 40,
                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Formula',
                            ),
                            onSubmitted: (String s) {
                              setState(() {
                                myController.text = s;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(5),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            onPressed: () {
                              _Add();
                            },
                          ),
                        )
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      buttonPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      children: [
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "And",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x039B),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _and();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "Or",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x56),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _or();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "Not",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x00AC),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _not();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "Implies",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x2192),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _implies();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Tooltip(
                            message: "Equals",
                            child: ElevatedButton(
                              child: Text(
                                String.fromCharCode(0x2194),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _mEquivalence();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              child: Text(
                                "Clear",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _Clear();
                              },
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: ((MediaQuery.of(context).size.width) / 3),
                          child: ListTile(
                            title:
                                Text("Default", style: TextStyle(fontSize: 15)),
                            leading: Radio<Property>(
                              value: Property.Default,
                              groupValue: _property,
                              onChanged: (Property? value) {
                                setState(() {
                                  _property = value;
                                  _updatePropertyText();
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: ((MediaQuery.of(context).size.width) / 3),
                          child: ListTile(
                            title: Text("Equivalence",
                                style: TextStyle(fontSize: 15)),
                            leading: Radio<Property>(
                              value: Property.Equivalence,
                              groupValue: _property,
                              onChanged: (Property? value) {
                                setState(() {
                                  _property = value;
                                  _updatePropertyText();
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: ((MediaQuery.of(context).size.width) / 3),
                          child: ListTile(
                            title: Text("Consistency",
                                style: TextStyle(fontSize: 15)),
                            leading: Radio<Property>(
                              value: Property.Consistency,
                              groupValue: _property,
                              onChanged: (Property? value) {
                                setState(() {
                                  _property = value;
                                  _updatePropertyText();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: ((MediaQuery.of(context).size.width) / 3),
                          child: ListTile(
                            title: Text("Validity",
                                style: TextStyle(fontSize: 15)),
                            leading: Radio<Property>(
                              value: Property.Validity,
                              groupValue: _property,
                              onChanged: (Property? value) {
                                setState(() {
                                  _property = value;
                                  _updatePropertyText();
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: ((MediaQuery.of(context).size.width) / 3),
                          child: ListTile(
                            title: Text("Entailment",
                                style: TextStyle(fontSize: 15)),
                            leading: Radio<Property>(
                              value: Property.Entailment,
                              groupValue: _property,
                              onChanged: (Property? value) {
                                setState(() {
                                  _property = value;
                                  _updatePropertyText();
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                        height: 40,
                        width: (MediaQuery.of(context).size.width) - 10,
                        // Center
                        child: Center(
                          child: Text('$format'),
                        )),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: listTest.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(listTest[index]),
                              subtitle: Text(
                                  (MetaData[index].toString()).substring(4)),
                              onTap: () {
                                _editSen(listTest[index], MetaData[index]);
                              },
                            ),
                          );
                        }),
                    Text(
                      '$message',
                      style: TextStyle(fontWeight: FontWeight.w700),
                      //style: Theme.of(context).textTheme.headline4,
                    )
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _displayInput,
            tooltip: 'Run',
            child: Text("Run"),
          ),
        ),
      ),
    );
  }
}
