import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:math_expressions/math_expressions.dart';
// import 'package:flutter/services.dart';

void main() {
  // SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primaryColor: Colors.blueGrey[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calculator'),
        ),
        body: SimpleCalculator(),
      ),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  @override
  SimpleCalculatorState createState() => SimpleCalculatorState();
}

class SimpleCalculatorState extends State<SimpleCalculator> {
  String formula = "";
  String numberDisplay = "";
  String inputs = "";
  var operators = ["x", ",", "-", "sqrt", "√", "÷", "=", "+", "(", ")"];

  @override
  Widget build(BuildContext context) {
    _buttonPressed(buttonAction, buttonValue) {
      switch (buttonValue) {
        case "=":
          {
            Parser p = Parser();
            Expression exp = p.parse(formula);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);
            numberDisplay += buttonValue +
                eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 3);
          }
          break;

        case "c":
          {
            numberDisplay = "";
            formula = "";
            inputs = "";
          }
          break;

        default:
          {
            inputs += buttonAction;
            if(operators.contains(buttonAction)) {
              var lastInput = inputs.substring(inputs.length -1);
              var secondToLastInput = inputs.substring(inputs.length - 2, inputs.length - 1);
              if(operators.contains(lastInput) & operators.contains(secondToLastInput)) {
                return;
              }
            }

            formula += buttonValue;
            numberDisplay += buttonAction;
          }
        break;
      }
    }

    Column _buildButtonColumn(string, value) {
      return Column(
        children: [
          Container(
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 90, height: 70),
              child: ElevatedButton(
                child: Text(string),
                onPressed: () {
                  setState(() {
                    _buttonPressed(string, value);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.white70;
                      return Colors.white; // Use the component's default.
                    },
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.all(15),
                  ),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Colors.blueGrey[700])),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.blueGrey[700],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget buttonSection = Container(
      // height: 700,
      // width: double.infinity,
      // padding: EdgeInsets.only(left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              _buildButtonColumn("C", "c"),
              _buildButtonColumn("(", "("),
              _buildButtonColumn(")", ")"),
              _buildButtonColumn("√", "sqrt"),
            ],
          ),
          Row(
            children: [
              _buildButtonColumn("7", "7"),
              _buildButtonColumn("8", "8"),
              _buildButtonColumn("9", "9"),
              _buildButtonColumn("÷", "/")
            ],
          ),
          Row(
            children: [
              _buildButtonColumn("4", "4"),
              _buildButtonColumn("5", "5"),
              _buildButtonColumn("6", "6"),
              _buildButtonColumn("x", "*")
            ],
          ),
          Row(
            children: [
              _buildButtonColumn("1", "1"),
              _buildButtonColumn("2", "2"),
              _buildButtonColumn("3", "3"),
              _buildButtonColumn("-", "-")
            ],
          ),
          Row(
            children: [
              _buildButtonColumn("0", "0"),
              _buildButtonColumn(",", "."),
              _buildButtonColumn("=", "="),
              _buildButtonColumn("+", "+")
            ],
          ),
        ],
      ),
    );

    Widget display = Container(
      width: double.infinity,
      alignment: Alignment.bottomRight,
      height: 280.7,
      child: Text(
        numberDisplay,
        style: TextStyle(
          fontSize: 40,
        ),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            display,
            buttonSection,
          ],
        ),
      ),
    );
  }
}
