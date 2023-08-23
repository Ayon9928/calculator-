import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool lock = false;
  String result = "0";
  String history = "";

  void calculate() {
    try {
      Expression exp = Parser().parse(history + result);
      ContextModel contextModel = ContextModel();
      setState(() {
        history = "";
        result = exp.evaluate(EvaluationType.REAL, contextModel).toString();
        lock = true;
      });
    } catch (e) {
      setState(() {
        history = "";
        result = "0";
        lock = false;
      });
    }
  }

  void updateResult(String n) {
    if (result != "0" && !lock) {
      result += n;
    } else {
      if (n != "0" && n != "00") {
        result = n;
        lock = false;
      }
    }
    setState(() {});
  }

  void updateHistory(String r, String s) {
    if (result != "0" && result.isNotEmpty && !result.contains('(')) {
      history += "$r$s";
      result = "";
    } else if (result.contains('(') && result.contains(')')) {
      history += "$r$s";
      result = "";
    } else if (result.contains('(')) {
      result += s;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<List<List<dynamic>>> basic = [
      [
        ["\u{02C5}", () {}],
        [
          "C",
          () {
            setState(() {
              result = "0";
            });
          }
        ],
        [
          "X",
          () {
            setState(() {
              result = "0";
              history = "";
            });
          }
        ],
        [
          "/",
          () {
            updateHistory(result, "/");
          }
        ],
      ],
      [
        [
          "(",
          () {
            updateResult("(");
          }
        ],
        [
          ")",
          () {
            updateResult(")");
          }
        ],
        [
          "%",
          () {
            updateHistory(result, "%");
          }
        ],
        [
          "*",
          () {
            updateHistory(result, "*");
          }
        ],
      ],
      [
        [
          "1",
          () {
            updateResult("1");
          }
        ],
        [
          "2",
          () {
            updateResult("2");
          }
        ],
        [
          "3",
          () {
            updateResult("3");
          }
        ],
        [
          "-",
          () {
            updateHistory(result, "-");
          }
        ],
      ],
      [
        [
          "4",
          () {
            updateResult("4");
          }
        ],
        [
          "5",
          () {
            updateResult("5");
          }
        ],
        [
          "6",
          () {
            updateResult("6");
          }
        ],
        [
          "+",
          () {
            updateHistory(result, "+");
          }
        ],
      ],
      [
        [
          "7",
          () {
            updateResult("7");
          }
        ],
        [
          "8",
          () {
            updateResult("8");
          }
        ],
        [
          "9",
          () {
            updateResult("9");
          }
        ],
        [
          "0",
          () {
            updateResult("0");
          }
        ],
        [
          "00",
          () {
            updateResult("00");
          }
        ],
        [
          ".",
          () {
            updateResult(".");
          }
        ],
        ["=", calculate],
      ]
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calculator",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff0c2234),
        elevation: 0,
      ),
      backgroundColor: const Color(0xff0c2234),
      body: Column(
        children: [
          history_block(history),
          const Spacer(),
          result_block(result),
          button_container_type1(basic[0]),
          button_container_type1(basic[1]),
          button_container_type1(basic[2]),
          button_container_type1(basic[3]),
          button_container_type2(basic[4]),
        ],
      ),
    );
  }

  Widget normal_button(
      BuildContext context, String key, void Function() function) {
    return Expanded(
      child: GestureDetector(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xff06354c),
              border: Border.all(color: Color(0xff0c2234))),
          child: Center(
            child: Text(
              key,
              style: defaultTextStyle(),
            ),
          ),
        ),
      ),
    );
  }

  Widget button_container_type1(List<List<dynamic>> obj) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          normal_button(context, obj[0][0], obj[0][1]),
          normal_button(context, obj[1][0], obj[1][1]),
          normal_button(context, obj[2][0], obj[2][1]),
          normal_button(context, obj[3][0], obj[3][1]),
        ],
      ),
    );
  }

  Widget button_container_type2(List<List<dynamic>> obj) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 3 / 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    normal_button(context, obj[0][0], obj[0][1]),
                    normal_button(context, obj[1][0], obj[1][1]),
                    normal_button(context, obj[2][0], obj[2][1]),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 3 / 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    normal_button(context, obj[3][0], obj[3][1]),
                    normal_button(context, obj[4][0], obj[4][1]),
                    normal_button(context, obj[5][0], obj[5][1]),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: obj[6][1],
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 1 / 4,
              color: const Color(0xff2c6c95),
              child: Center(
                child: Text(
                  obj[6][0],
                  style: defaultTextStyle(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Row history_block(String history) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 20),
          child: Text(history,
              style: defaultTextStyle(),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }

  Row result_block(String result) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 20),
          child: Text(result,
              style: resulyTextStyle(),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }

  TextStyle defaultTextStyle() => const TextStyle(
      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20);

  TextStyle resulyTextStyle() => const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24);
}
