/// Authors: Ahmed Ghoor, Mthokozeleni Sithole, Ahmed Khan
/// CSC3003S Capstone Project: TT4SPL
/// 6 October 2021

import 'dart:math';

import 'Equation.dart';

class TruthTableGenerator {
  late Equation fullEquation;
  late List<String> input;
  late List<List> truthTable;
  late int numEquations;
  late int col;
  late int rows;
  List<String> symbols = ["[", "~", "&", "|", ">", "="];
  List<String> precedance = ["(", "not", "and", "or", "implies", "equals"];

  /// Generates a table for input given as a list of strings.
  TruthTableGenerator(List<String> input) {
    this.input = input;
    List<String> inputs = input;
    List<String> input1;
    fullEquation = Equation(input);
    List<Equation> equations = <Equation>[];
    Equation equation1;
    Equation equation2;
    int splitIndex;
    numEquations = 1;

    if (inputs.contains(";")) {
      while (inputs.contains(";")) {
        numEquations++;
        splitIndex = inputs.indexOf(";");
        input1 = inputs.sublist(0, splitIndex);
        inputs = inputs.sublist(splitIndex + 1);
        equation1 = Equation(input1);
        equations.add(equation1);
      }
    }
    equation1 = Equation(inputs);
    equations.add(equation1);
    truthTable = generateTableSolutions(equations);

    if (numEquations > 1) {
      fullEquation.getAtoms().removeLast();
      for (int i = 0; i < numEquations; i++) {
        fullEquation
            .getAtoms()
            .add(equations[i].getAtoms()[equations[i].getAtoms().length - 1]);
      }
    }
  }

  List<List> generateTableSolutions(List<Equation> e) {
    List<List> toReturn;

    List<List> tableAll = generateTable(fullEquation);
    List<List> tableAllDetail = generateTable(fullEquation);

    List<List<bool>> solutions = List.generate(
        rows, (i) => List.filled(2, false, growable: true),
        growable: true);

    for (int i = 0; i < e.length; i++) {
      solutions[i] = generateSolution(tableAllDetail, e[i]);
    }
    for (int i = 0; i < rows; i++) {
      tableAll[i].removeAt(tableAll[i].length - 1);
    }

    for (int i = 0; i < e.length; i++) {
      for (int j = 0; j < rows; j++) {
        tableAll[j].add(solutions[i][j]);
      }
    }

    toReturn = tableAll;
    return toReturn;
  }

  /// Generates and returns Table for input that requires one equation
  List<List> generateTable(Equation e) {
    this.rows = (pow(2, e.getNumSteps())).toInt();
    int columns = e.getNumSteps() + 1;

    List<List> toReturn = List.generate(
        rows, (i) => List.filled(columns, false, growable: true),
        growable: false);

    List<List> detailTable = List.generate(
        rows, (i) => List.filled(columns, false, growable: true),
        growable: false);

    toReturn = setAtomValues(toReturn, e);
    detailTable = setAtomValues(detailTable, e);
    return toReturn;
  }

  /// Generates solution column of the table given the values of the atoms
  List<bool> generateSolution(table, equation) {
    List<bool> toReturn = <bool>[];
    String operator;
    int operatorPos;
    int boperatorPos;
    int brightPos;
    int bStartSearch;
    int startIndex = 0;
    int endIndex = 5;
    bool bracketOpen = false;
    List<String> brackets = <String>[];

    int p = 0;

    while (equation.getInput().length > 1) {
      if (bracketOpen && brackets.length == 1) {
        bracketOpen = false;
        p = 0;

        equation.input.removeAt(startIndex);

        equation.input.removeAt(startIndex + 1);
        continue;
      }

      operator = precedance[p];

      if (equation.input.contains(precedance[p])) {
        if (p == 0) {
          bracketOpen = true;
          startIndex = equation.getInput().indexOf("(");
          endIndex = equation.getInput().indexOf(")");

          brackets = equation.getInput().sublist(startIndex + 1, endIndex);
          while (true) {
            if (brackets.contains("(")) {
              startIndex = equation.getInput().indexOf("(", startIndex + 1);

              brackets = equation.getInput().sublist(startIndex + 1, endIndex);
              continue;
            } else {
              break;
            }
          }
          p++;

          continue;
        }

        if (bracketOpen) {
          if (!brackets.contains(precedance[p])) {
            p++;
            continue;
          }
        }

        operatorPos = getOpIndex(startIndex, equation, operator, bracketOpen);
        String right = equation.getInput()[operatorPos + 1];
        int rightPos;

        if (p == 1) {
          if (right == "not") {
            // Double Negation
            operatorPos = operatorPos + 1;
            right = equation.getInput()[operatorPos + 1];
          }

          rightPos = fullEquation.getallSteps().indexOf(right);

          for (int i = 0; i < rows; i++) {
            table[i].insert((rightPos + 1), notOp(table[i][rightPos]));
          }
          fullEquation.insertAtom(rightPos + 1, ("{~" + right + "}"));

          equation.getInput().insert(operatorPos + 1, ("{~" + right + "}"));

          equation.getInput().removeAt(operatorPos + 2);
          equation.getInput().removeAt(operatorPos);
          if (bracketOpen) {
            boperatorPos = brackets.indexOf(operator);
            brightPos = brackets.indexOf(right);
            brackets.insert(boperatorPos + 1, ("{~" + right + "}"));
            brackets.removeAt(boperatorPos + 2);
            brackets.removeAt(boperatorPos);
          }
        } else {
          rightPos = fullEquation.getallSteps().indexOf(right);

          String left = equation.getInput()[operatorPos - 1];

          int leftPos = fullEquation.getallSteps().indexOf(left);

          for (int i = 0; i < rows; i++) {
            table[i].insert(
                (rightPos + 1),
                calculator(
                    precedance[p], table[i][leftPos], table[i][rightPos]));
          }

          fullEquation.insertAtom(
              rightPos + 1, ("{" + left + symbols[p] + right + "}"));
          equation
              .getInput()
              .insert(operatorPos + 1, ("{" + left + symbols[p] + right + "}"));

          equation.getInput().removeAt(operatorPos + 2);
          equation.getInput().removeRange(operatorPos - 1, operatorPos + 1);
          if (bracketOpen) {
            boperatorPos = brackets.indexOf(operator);
            brightPos = brackets.indexOf(right);
            brackets.insert(
                boperatorPos + 1, ("{" + left + symbols[p] + right + "}"));
            brackets.removeAt(boperatorPos + 2);
            brackets.removeRange(boperatorPos - 1, boperatorPos + 1);
          }
        }
      } else {
        p++;
        continue;
      }
    }

    int solutionIndex =
        fullEquation.getallSteps().indexOf(equation.getInput()[0]);

    for (int i = 0; i < rows; i++) {
      toReturn.add(table[i][solutionIndex]);
    }
    return toReturn;
  }

  /// Returns index of the operator by taking into account if a bracket is open
  int getOpIndex(start, equation, operator, bool bracketGate) {
    if (bracketGate) {
      return equation.getInput().indexOf(operator, start);
    } else {
      return equation.getInput().indexOf(operator);
    }
  }

  /// Sets the individual atom values for the table
  List<List> setAtomValues(List<List> table, equation) {
    List<List> toReturn = table;
    //One of the most elegant pieces of code you will ever see
    int skip = rows ~/ 2;
    int count = 0;
    bool temp = true;

    for (int i = 0; i < equation.getNumSteps(); i++) {
      for (int j = 0; j < rows; j++) {
        if (count < skip) {
        } else {
          temp = !temp;
          count = 0;
        }
        table[j][i] = temp;
        count++;
      }
      skip = skip ~/ 2;
    }

    return toReturn;
  }

  ///returns final table
  List<List> getTruthTable() {
    return truthTable;
  }

  ///returns number of equations being outputted
  int getNumEquations() {
    return numEquations;
  }

  /// all gates combined
  bool calculator(String operator, bool a, bool b) {
    if (operator == "and") {
      return andOp(a, b);
    } else if (operator == "or") {
      return orOp(a, b);
    } else if (operator == "implies") {
      return impOp(a, b);
    } else {
      return eqlOp(a, b);
    }
  }

  /// and gate
  bool andOp(bool a, bool b) {
    return (a && b);
  }

  /// or gate
  bool orOp(bool a, bool b) {
    return (a || b);
  }

  /// implies gate
  bool impOp(bool a, bool b) {
    bool toReturn = true;
    if (a && !b) {
      toReturn = false;
    }
    return toReturn;
  }

  /// equals gate
  bool eqlOp(bool a, bool b) {
    bool toReturn = false;
    if ((a && b) || (!a && !b)) {
      toReturn = true;
    }
    return toReturn;
  }

  /// not gate
  bool notOp(bool a) {
    return !a;
  }
}

/// Test Backend
void main() {
  List<String> test1 = ["p", "or", "q", "and", "r"];
  List<String> test2 = ["w", "and", "y", "implies", "h"];
  List<String> test3 = ["not", "p", "or", "q"];
  List<String> test4 = ["p", "and", "q", "equals", "not", "p", "or", "q"];
  List<String> test6 = ["a", "and", "(", "b", "or", "c", ")"];
  List<String> test7 = ["not", "not", "p"];
  List<String> test5 = [
    "w",
    "and",
    "y",
    "implies",
    "h",
    ";",
    "w",
    "implies",
    "(",
    "y",
    "implies",
    "h",
    ")"
  ];
  List<String> test8 = [
    "(",
    "(",
    "a",
    "or",
    "not",
    "d",
    ")",
    "and",
    "not",
    "(",
    "a",
    "and",
    "d",
    ")",
    ")",
    "implies",
    "not",
    "d"
  ];
  List<String> test9 = [
    "q",
    "and",
    "r",
    ";",
    "q",
    "or",
    "r",
    ";",
    "q",
    "implies",
    "r"
  ];
  /*List<List<String>> test10 = [
    ["a", "and", "b"],
    ["a", "or", "b"]
  ];*/
  List<String> test10 = [
    "a",
    "implies",
    "d",
    ";",
    "a",
    "and",
    "b",
    "or",
    "c",
    ";",
    "f",
    "equals",
    "d"
  ];
  List<String> test11 = ["a", "and", "b", ";", "a", "or", "b"];
  List<String> test12 = [
    "a",
    "and",
    "b",
    "or",
    "c",
    ";",
    "a",
    "implies",
    "d",
    "and",
    "f"
  ];
  List<String> test13 = [
    "a",
    "and",
    "b",
    ";",
    "a",
    "or",
    "c",
    ";",
    "a",
    "or",
    "b",
    "implies",
    "c"
  ];
  List<String> test14 = "not ( E and ( H implies ( B and E ) ) )".split(" ");
  List<String> test15 = "( F or ( G or D ) ) or ( P or ( S or R ) )".split(" ");
  //print(test14);
  List<String> test16 =
      "J and ( ( E or F ) and ( not E and not F ) ) implies not J".split(" ");
  List<String> test17 =
      "D implies ( not N implies ( ( B and C ) equals not ( ( L implies J ) or X ) ) )"
          .split(" ");

  TruthTableGenerator ttg = TruthTableGenerator(test17);
  print(ttg.fullEquation.getAtoms());
  for (List i in ttg.getTruthTable()) {
    print(i);
  }
}
