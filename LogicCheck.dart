/// Authors: Ahmed Ghoor, Mthokozeleni Sithole, Ahmed Khan
/// CSC3003S Capstone Project: TT4SPL
/// 6 October 2021

//Each function in this class represents one logical check.
//Each check returns a boolean value to state if the check is true or false

class LogicCheck {
  //Variables
  List<List> tt = [];
  List<String> functions = [];
  String input = "";
  int funNum = 0;
  int metIndex = 0;
  List META = [];
  int start = 0;

  //Constructor
  LogicCheck(List<List> tt1, String inputList, int argNum, List meta) {
    tt = tt1;
    input = inputList;
    funNum = argNum;
    List<String> atoms = input.split(',');
    for (int i = funNum - 1; i > -1; i--) {
      functions.add(atoms[atoms.length - 1 - i]);
    }
    META = meta;

    for (int i = 0; i < meta.length; i++) {
      print(meta[i].toString());
      if ((meta[i].toString() == "PCE.Entails") ||
          (meta[i].toString() == "PCE.Conclusion")) {
        metIndex = i;
      }
    }

    start = functions.length - META.length;
  }

  //Functions

  //Truth functional truth
  //A sentence P of SL is TRUTH-FUNCTIONALLY TRUE if
  //and only if P is true on every truth value assignment
  bool tfTruth(List<List> tt1, int num) {
    int falsity = 0;
    bool answer;

    for (int i = 0; i < tt1.length; i++) {
      if (tt1[i][tt1[i].length - funNum + num] == false) {
        falsity++;
      }
    }

    if (falsity == 0) {
      answer = true;
    } else {
      answer = false;
    }

    return answer;
  }

  //Truth-functional faslity
  //A sentence P of SL is TRUTH-FUNCTIONALLY FALSE if
  //and only if P is false on every truth value assignment
  bool tfFalse(List<List> tt1, int num) {
    int honesty = 0;
    bool answer;
    for (int i = 0; i < tt1.length; i++) {
      if (tt1[i][tt1[i].length - funNum + num] == true) {
        honesty++;
      }
    }

    if (honesty == 0) {
      answer = true;
    } else {
      answer = false;
    }

    return answer;
  }

  //Truth functional inderterminacy

  //A sentence P of SL is TRUTH-FUNCTIONALLY INDETERMINATE
  //if and only if P is neither truth-functionally true
  //nor truth-functionally false

  bool tfIndeterminacy(List<List> tt1, int num) {
    bool tFuncT = tfTruth(tt1, num);
    bool tFuncF = tfFalse(tt1, num);
    bool answer;
    if ((tFuncT == false) && (tFuncF == false)) {
      answer = true;
    } else {
      answer = false;
    }

    return answer;
  }

  //Truth functional equivalence

  //A set of sentences of SL is TRUTH-FUNCTIONALLY EQUIVALENT
  //if and only if there is no truth-value assignment on which
  //P and Q have different truth values

  bool tfEquivalence(List<List> tt1) {
    bool answer = true;
    for (int i = 0; i < tt1.length; i++) {
      if ((tt1[i][tt1[i].length - funNum + 0]) !=
          (tt1[i][tt1[i].length - funNum + 1])) {
        answer = false;
      }
    }

    return answer;
  }
  //Truth-functional consistance

  //A sentence SL is TRUTH-FUNCTIONALLY CONSISTANT if
  //and only there is at least one truth-valie assignment on which
  //all the members of the set are true. A set of sentences of SL
  //is TRUTH-FUNCTIONALLY INCONSISTANT if and onl if it is
  //not truth-functionally consistant.

  bool tfConsistant(List<List> tt1) {
    bool answer = false;
    for (int i = 0; i < tt1.length; i++) {
      int check = 0;

      for (int j = tt1[i].length - funNum; j < tt1[i].length; j++) {
        if (tt1[i][j] == true) {
          check++;
        }
      }

      if (check == funNum) {
        answer = true;
      }
    }
    return answer;
  }

  //Truth functoinal entailment

  //A set T of sentences of SL TRUTH-FUNCTIONALLY ENTAILS a
  //sentence P if and only if there is no truth-value assignment
  //on which every member of T is true and P is false

  bool tfEntVal(List<List> tt) {
    bool answer = true;
    for (int i = 0; i < tt.length; i++) {
      int check = 0;

      for (int j = tt[i].length - META.length; j < tt[i].length; j++) {
        if ((j == tt[i].length - META.length + metIndex)) {
          continue;
        }
        if ((tt[i][j] == true)) {
          check++;
          //print("Check = $check");
        }
      }
      //print("Main check = $check");
      //bool thing = tt[i][tt[i].length - 1];
      //print("Final = $thing");

      if ((check == META.length - 1) &&
          (tt[i][tt[i].length - META.length + metIndex] == false)) {
        answer = false;
        //print(functions[start + metIndex]);
        //print(metIndex);
      }
    }
    return answer;
  }

  //Truth-functional validity

  //An argument of SL is TRUTH-FUNCTIONALLY VALID if and only if
  //there is no truth-value assignment on which all the premises
  //are truth and the conclusion is false. An argument of SL is
  //TRUTH-FUNCTIONALLY INVALID if and only if it is not truth-functionally
  //valid.

  // Validity method has been merged with Entailment method as they are functionally the same thing

  //This method returns a string on logical assertions about a given
  //truth table to be displayed on the GUI
  String getMessages() {
    String message = "";
    for (int i = 0; i < functions.length; i++) {
      if (tfTruth(tt, i) == true) {
        message = message +
            "\n(" +
            functions[i] +
            " )" +
            " is Truth-Functionally TRUE \n";
      }
      if (tfFalse(tt, i) == true) {
        message = message +
            "\n(" +
            functions[i] +
            " )" +
            " is Truth-Functionally FALSE \n";
      }
      if (tfIndeterminacy(tt, i) == true) {
        message = message +
            "\n(" +
            functions[i] +
            " )" +
            " is Truth-Functionally INDETERMINANT \n";
      }
    }

    return message;
  }

  //Generates output for entailment check
  String getEntailMessage() {
    String message = "";
    if (tfEntVal(tt) == true) {
      message = message +
          " The given set of sentences ENTAILS " +
          "( " +
          functions[start + metIndex] +
          " )\n";
    } else {
      message = message +
          "The given set does NOT entail ( " +
          functions[start + metIndex] +
          " )\n";
    }
    return message;
  }

  //Generates output for validity check
  String getValidityMessage() {
    String message = "";
    if (tfEntVal(tt) == true) {
      message = message + " The given argument is VALID\n";
    } else {
      message = message + "The given argument is INVALID\n";
    }
    return message;
  }

  //Generates output for Equivalence check
  String getEquivalenceMessage() {
    String message = "";
    if (tfEquivalence(tt) == true) {
      message = message + " The given sentences are EQUIVALENT\n";
    } else {
      message = message + "The given sentences are NOT equivalent\n";
    }
    return message;
  }

  //Generates output for consistancy check
  String getConsistancyMessage() {
    String message = "";
    if (tfConsistant(tt) == true) {
      message = message + " The given set is CONSISTANT\n";
    } else {
      message = message + "The given set is INCONSISTANT\n";
    }
    return message;
  }
}
