/// Authors: Ahmed Ghoor, Mthokozeleni Sithole, Ahmed Khan
/// CSC3003S Capstone Project: TT4SPL
/// 6 October 2021


class Equation {
  late List<String> input;
  late int numInput;
  late List<String> allSteps;
  late int numSteps;
  late List<String> atoms;
  late int numAtoms;
  late List<bool> completed;
  late List<String> operators;
  late int numOperators;

  /// Encapsulate attributes of the input
  Equation(List<String> input) {
    this.input = input;
    this.allSteps = <String>[];
    this.atoms = <String>[];
    this.operators = <String>[];
    for (int i = 0; i < input.length; i++) {
      if (input[i].contains("not") ||
          input[i].contains("and") ||
          input[i].contains("or") ||
          input[i].contains("implies") ||
          input[i].contains("equals") ||
          input[i].contains("(") ||
          input[i].contains(")")) {
        //might be a better way to code this
        operators.add(input[i]);
      } else if (atoms.contains(input[i]) || input[i].contains(";")) {
        continue;
      } else {
        allSteps.add(input[i]);
        atoms.add(input[i]);
      }
    }
    completed = List.filled(allSteps.length, false);

    String solution = "";
    for (int i = 0; i < input.length; i++) {
      solution = solution + " " + input[i];
    }
    atoms.add(solution);

    numInput = input.length;
    numAtoms = atoms.length;
    numSteps = allSteps.length;
    numOperators = operators.length;
  }

  /// returns input array
  List<String> getInput() {
    return input;
  }

  /// returns input arrray length
  int getNumInput() {
    return input.length;
  }

  /// returns array with all the steps to reach the solution
  List<String> getallSteps() {
    return allSteps;
  }

  /// returns getallSteps length
  int getNumSteps() {
    return allSteps.length;
  }

  /// returns all the atoms in the equation
  List<String> getAtoms() {
    return atoms;
  }

  /// returns the number of atoms in the equation
  int getNumAtoms() {
    return atoms.length;
  }

  /// returns list operators in input
  List<String> getOperators() {
    return operators;
  }

  /// returns number of operators in input
  int getNumOperators() {
    return operators.length;
  }

  /// inserts element into allsteps array
  void insertAtom(int index, String element) {
    allSteps.insert(index, element);
  }

  /// inserts element into input array
  void insertInput(int index, String element) {
    input.insert(index, element);
  }

  /// removes a range of index's in input array
  void removeInput(List<int> range) {
    for (int i = 0; i < range.length; i++) {
      input.removeAt(range[i]);
    }
  }
}
