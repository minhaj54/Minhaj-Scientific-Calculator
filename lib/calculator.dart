import 'dart:math';

import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentNumber = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;
  bool _isRadians = true;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentNumber = "";
        _operation = "";
        _num1 = 0;
        _num2 = 0;
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        _num1 = double.parse(_output);
        _operation = buttonText;
        _currentNumber = "";
      } else if (buttonText == "=") {
        _num2 = double.parse(_currentNumber);
        _calculateResult();
      } else if (buttonText == "sin" ||
          buttonText == "cos" ||
          buttonText == "tan" ||
          buttonText == "log" ||
          buttonText == "ln" ||
          buttonText == "√") {
        _num1 = double.parse(_output);
        _operation = buttonText;
        _calculateResult();
      } else if (buttonText == "π") {
        _currentNumber = pi.toString();
        _output = _currentNumber;
      } else if (buttonText == "e") {
        _currentNumber = e.toString();
        _output = _currentNumber;
      } else if (buttonText == "Rad/Deg") {
        _isRadians = !_isRadians;
      } else {
        _currentNumber += buttonText;
        _output = _currentNumber;
      }
    });
  }

  void _calculateResult() {
    switch (_operation) {
      case "+":
        _output = (_num1 + _num2).toString();
        break;
      case "-":
        _output = (_num1 - _num2).toString();
        break;
      case "×":
        _output = (_num1 * _num2).toString();
        break;
      case "÷":
        _output = (_num1 / _num2).toString();
        break;
      case "sin":
        _output = (_isRadians ? sin(_num1) : sin(_num1 * pi / 180)).toString();
        break;
      case "cos":
        _output = (_isRadians ? cos(_num1) : cos(_num1 * pi / 180)).toString();
        break;
      case "tan":
        _output = (_isRadians ? tan(_num1) : tan(_num1 * pi / 180)).toString();
        break;
      case "log":
        _output = (log(_num1) / ln10) as String;
        break;
      case "ln":
        _output = log(_num1).toString();
        break;
      case "√":
        _output = sqrt(_num1).toString();
        break;
    }
    _currentNumber = _output;
  }

  Widget _buildButton(String buttonText, Color buttonColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhaj Calculator'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Text(
              _output,
              style: const TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Divider(color: Colors.grey[800], thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton("sin", Colors.deepPurple[400]!),
                    _buildButton("cos", Colors.deepPurple[400]!),
                    _buildButton("tan", Colors.deepPurple[400]!),
                    _buildButton("π", Colors.deepPurple[400]!),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("log", Colors.deepPurple[400]!),
                    _buildButton("ln", Colors.deepPurple[400]!),
                    _buildButton("√", Colors.deepPurple[400]!),
                    _buildButton("e", Colors.deepPurple[400]!),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("7", Colors.grey[800]!),
                    _buildButton("8", Colors.grey[800]!),
                    _buildButton("9", Colors.grey[800]!),
                    _buildButton("÷", Colors.deepPurple),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4", Colors.grey[800]!),
                    _buildButton("5", Colors.grey[800]!),
                    _buildButton("6", Colors.grey[800]!),
                    _buildButton("×", Colors.deepPurple),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("1", Colors.grey[800]!),
                    _buildButton("2", Colors.grey[800]!),
                    _buildButton("3", Colors.grey[800]!),
                    _buildButton("-", Colors.deepPurple),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("C", Colors.red[400]!),
                    _buildButton("0", Colors.grey[800]!),
                    _buildButton("=", Colors.deepPurple),
                    _buildButton("+", Colors.deepPurple),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildButton("Rad/Deg", Colors.deepPurple[300]!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
