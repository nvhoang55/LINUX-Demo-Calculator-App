import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ColorScheme.dart';

String output = "";
String expressions = "";

bool equalButtonPressed = false;

var numbers = new RegExp(r'[0-9]');
var operators = new RegExp(r'/*-+^%');

String calculatedValue = "";
num firstNumber = 0;
num secondNumber = 0;
String operand = "";

class MyHomePage extends StatefulWidget
{
    MyHomePage({Key key, this.title}) : super(key: key);
    final String title;

    @override
    _MyHomePageState createState()
    => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: new Container(

                child: new Column(children: <Widget>[

//Phạm Trung Hiếu
//                    Display answer field
                    new Container(

                            alignment: Alignment.centerRight,

//                        Modify answer's field margin
                            padding: new EdgeInsets.symmetric(
                                    vertical: 24.0,
                                    horizontal: 12.0
                            ),

//                            Modify answer's field style
                            child: new Text(output,
                                style: new TextStyle(
                                        fontSize: 80.0,
                                        fontWeight: FontWeight.bold
                                ),
                            )
                    ),

//                    Display expressions
                    new Container(

                            alignment: Alignment.centerRight,

//                        Modify calculations' field margin
                            padding: new EdgeInsets.symmetric(
                                    horizontal: 12.0
                            ),

//                            Modify calculations' field style
                            child: new Text(expressions,
                                style: new TextStyle(
                                    fontSize: 40.0,
                                ),
                            )
                    ),


//Trần Lê Hoàng
//                    Put number rows to the bottom
                    new Expanded(
                        child: new Divider(),
                    ),

//                    Build button rows
                    buildFirstRow(),
                    buildRowOf4('7', '8', '9', '*'),
                    buildRowOf4('4', '5', '6', '-'),
                    buildRowOf4('1', '2', '3', '+'),
                    buildRowOf4('000', '0', '.', '='),

                ],),
            ),
        );
    }

//    Special row for AC button and some operator buttons
    Row buildFirstRow()
    {
        return new Row(
                children: [
                    buildButton('AC', backgroundColor: RUBY_RED),
                    buildButton('^', backgroundColor: DARK_IMPERIAL_BLUE),
                    buildButton('%', backgroundColor: DARK_IMPERIAL_BLUE),
                    buildButton('/', backgroundColor: DARK_IMPERIAL_BLUE)
                ]
        );
    }

    Row buildRowOf4(String first, second, third, fourth)
    {
        return new Row(
                children: [
                    buildButton(first),
                    buildButton(second),
                    buildButton(third),
                    buildButton(fourth, backgroundColor: DARK_IMPERIAL_BLUE)
                ]
        );
    }

    Widget buildButton(String buttonNumber,
                       {MaterialColor backgroundColor = MAASTRICHT_BLUE,
                           MaterialColor textColor = BABY_POWDER})
    {
        return new Expanded(
            child: new MaterialButton(
                child: new Text(
                    buttonNumber,

                    style: new TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                    ),
                ),

                onPressed: ()
                => handleButtonPressed(buttonNumber),

                color: backgroundColor,
                textColor: textColor,
                height: 100,
            ),
        );
    }

//    Nguyễn Việt Hoàng
    handleButtonPressed(String buttonText)
    {
//        if (equalButtonPressed && !buttonText.contains(numbers))
//        {
//            print("is running");
//            equalButtonPressed = false;
//
//            firstNumber = num.tryParse(calculatedValue);
//            calculatedValue = "";
//            operand = "";
//
//            expressions = "${firstNumber} ${buttonText} ";
//        }

        if (buttonText == "AC")
        {
            reset();
        }
        else if (buttonText == "+"
                || buttonText == "-")
        {
            operand = buttonText;
            firstNumber = num.tryParse(calculatedValue);
            calculatedValue = "";
            expressions += " ${operand} ";
        }
        else if (buttonText == "*"
                || buttonText == "/")
        {
            operand = buttonText;
            firstNumber = num.tryParse(output);
            calculatedValue = "";

            if (expressions.contains("+") || expressions.contains("-"))
            {
                expressions = "(${expressions}) ${operand} ";
            }
            else
            {
                expressions += " ${operand} ";
            }
        }
        else if (buttonText == ".")
        {
            if (calculatedValue.contains("."))
            {
                print("You already pressed the dot button");
                return;
            }
            else
            {
                calculatedValue += buttonText;
                expressions += buttonText;
            }
        }
        else if (buttonText == "=" && !equalButtonPressed)
        {
            equalButtonPressed = true; //to block spamming press "=" button that leads to misleading output display

            secondNumber = num.tryParse(calculatedValue);

            calculatedValue = getAnswerByOperand(operand);
        }
        else if (equalButtonPressed && buttonText.contains(numbers))
        {
            reset();

            calculatedValue += buttonText;
            expressions += buttonText;
        }

        else if (buttonText.contains(numbers)) //when press number buttons
        {
            calculatedValue += buttonText;
            expressions += buttonText;
        }

        print(calculatedValue);

        setDisplayState(calculatedValue);
    }

    String getAnswerByOperand(String operand)
    {
        print(operand);

        switch (operand)
        {
            case "+":
                return (firstNumber + secondNumber).toString();

            case "-":
                return (firstNumber - secondNumber).toString();

            case "*":
                return (firstNumber * secondNumber).toString();

            case "/":
                return (firstNumber / secondNumber).toString();

            default:
                return "Undifined operand";
        }
    }

    void setDisplayState(String content)
    {
        setState(()
        {
            output = getFormattedContent(content);
        });
    }

    String getFormattedContent(answer)
    {
        if (answer == "")
        {
            return answer;
        }
        else
        {
            num finalOutput = num.tryParse(answer);
            var formatter = new NumberFormat();

            if (finalOutput is int) //Check if output is an integer
            {
                return formatter.format(finalOutput);
            }
            else
            {
                num roundedOutput = num.tryParse(finalOutput
                        .toStringAsFixed(2)); //round the output to 2 digits after decimal point
                return formatter.format(roundedOutput);
            }
        }
    }

    void reset()
    {
        expressions = "";
        output = "";
        calculatedValue = "";
        firstNumber = 0.0;
        secondNumber = 0.0;
        operand = "";
        equalButtonPressed = false;
    }
}