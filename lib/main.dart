import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:math';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double sourceCharge = 0.0;
  aVector source = aVector(0.0,0.0,0.0);
  List<bool> inputc = List.filled(6, false);
  List<bool> inputx = List.filled(6, false);
  List<bool> inputy = List.filled(6, false);
  List<bool> inputz = List.filled(6, false);
  List<TextEditingController> Chargecontrollers = [];
  List<TextEditingController> Xaxiscontrollers = [];
  List<TextEditingController> Yaxiscontrollers = [];
  List<TextEditingController> Zaxiscontrollers = [];
  bool allValuesEntered = false;
  int NumofChar = 0;
  List<double> Chargevalues = [];
  List<aVector> axisValues =[];
  List<aVector> dValues = [];
  List<double> distancesR = []; //以后更改为保留两位小数double/string
  List<aVector> Evectors =[];
  aVector axisE = aVector(0.0, 0.0, 0.0);
  double E = 0.0;
  aVector Evector = aVector(0.0, 0.0, 0.0);
  aVector axisF = aVector(0.0, 0.0, 0.0);

  void initState(){
    super.initState();
    setState(() {
      _addNewRow();
    });
  }

  void _addNewRow(){
    
      if (NumofChar < 5){
        NumofChar++;
        Chargecontrollers.add(TextEditingController());
        Xaxiscontrollers.add(TextEditingController());
        Yaxiscontrollers.add(TextEditingController());
        Zaxiscontrollers.add(TextEditingController());
        Chargevalues.add(0.0);
        axisValues.add(aVector(0.0, 0.0, 0.0));
        dValues.add(aVector(0.0, 0.0, 0.0));
        distancesR.add(0.0);
        Evectors.add(aVector(0.0, 0.0, 0.0));
      }
    
  }


  void _Calculate(){
    for(int j=0; j<NumofChar; j++){
      dValues[j].x= axisValues[j].x - source.x;
      dValues[j].y = axisValues[j].y - source.y;
      dValues[j].z = axisValues[j].z - source.z;
      distancesR[j] = double.parse(sqrt(pow(dValues[j].x, 2) + pow(dValues[j].y, 2) + pow(dValues[j].z, 2)).toStringAsExponential(2));
      Evectors[j].x = Chargevalues[j] * dValues[j].x / (4 * pi * pow(8.854, -12) * pow(distancesR[j], 3));
      Evectors[j].y = Chargevalues[j] * dValues[j].y / (4 * pi * pow(8.854, -12) * pow(distancesR[j], 3));
      Evectors[j].z = Chargevalues[j] * dValues[j].z / (4 * pi * pow(8.854, -12) * pow(distancesR[j], 3));
      axisE.x = axisE.x + Evectors[j].x; axisE.y = axisE.y + Evectors[j].y; axisE.z = axisE.z + Evectors[j].z;
      E = sqrt(pow(axisE.x,2) + pow(axisE.y,2) +(pow(axisE.z,2)));
      Evector.x = axisE.x / E; Evector.y = axisE.y / E; Evector.z = axisE.z / E;
      axisF.x = double.parse((axisE.x * sourceCharge).toStringAsExponential(2)); axisF.y = double.parse((axisE.y * sourceCharge).toStringAsExponential(2)); axisF.z = double.parse((axisE.x * sourceCharge).toStringAsExponential(2));
    }
  }

  bool updateinput(List<bool> inputx, List<bool> inputy, List<bool> inputz, List<bool> inputc, int NumofChar, bool allValuesEntered){
    bool checkinput = false;
    for (int i = 0; i < NumofChar; i++){
      if (inputx[i]!= false && inputy[i] != false && inputz[i] != false && inputc[i] != false) {
        checkinput = true;
      } else {
        checkinput = false;
        break;
      }
    }
    allValuesEntered =  checkinput && inputx[5] && inputy[5] && inputz[5] && inputc[5];
    return allValuesEntered;
  }

  String _seperateDouble (double num2sep) {
    String numStr = num2sep.toStringAsExponential(2);
    List<String> list4sep = numStr.split('e');
    double baseNum = double.parse(list4sep[0]);
    int aNum = int.parse(list4sep[1]);
    return "$baseNum \\times 10 ^ {$aNum}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Electrosatic Field Calculator',style: TextStyle(fontSize: 22.0, letterSpacing: 1.1, fontWeight: FontWeight.bold,)),
        backgroundColor: Colors.lightBlue[900],
        foregroundColor: Colors.white,
      ),
      body:SingleChildScrollView(
        child: Column(children: [
          Text('Input your data for Source charge:',style: TextStyle(fontSize: 18.0, )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'X-axis',
                    ),
                    onChanged: (value) {
                      setState(() {
                        source.x = double.tryParse(value) ?? 0.0;
                        inputx[5] = true;
                        allValuesEntered = updateinput(inputx, inputy, inputz, inputc, NumofChar, allValuesEntered);
                        _Calculate();
                      });
                    }
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Y-axis',
                    ),
                    onChanged: (value) {
                      setState(() {
                        source.y = double.tryParse(value) ?? 0.0;
                        inputy[5] = true;
                        allValuesEntered = updateinput(inputx, inputy, inputz, inputc, NumofChar, allValuesEntered);
                        _Calculate();
                      });
                    }
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Z-axis',
                    ),
                    onChanged: (value) {
                      setState(() {
                        source.z = double.tryParse(value) ?? 0.0;
                        inputz[5] = true;
                        allValuesEntered = updateinput(inputx, inputy, inputz, inputc, NumofChar, allValuesEntered);
                        _Calculate();
                      });
                    }
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Charge/nC',
                    ),
                    onChanged: (value) {
                      setState(() {
                        sourceCharge = double.tryParse(value) ?? 0.0;
                        inputc[5] = true;
                        allValuesEntered = updateinput(inputx, inputy, inputz, inputc, NumofChar, allValuesEntered);
                        _Calculate();
                      });
                    }
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.outlined_flag),),
            ],
          ),
          Text('Input your data for Field charges (up to 5):',style: TextStyle(fontSize: 18.0, )),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: Chargecontrollers.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: Xaxiscontrollers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'X-axis',
                        ),
                        onChanged: (value) {
                          setState(() {
                            axisValues[index].x = double.tryParse(value) ?? 0.0;
                            inputx[index] = true;
                            allValuesEntered = updateinput(inputx, inputy, inputz, inputc, NumofChar, allValuesEntered);
                            _Calculate();
                          });
                        }
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: Yaxiscontrollers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Y-axis',
                        ),
                        onChanged: (value) {
                          setState(() {
                            axisValues[index].y = double.tryParse(value) ?? 0.0;
                            inputy[index] = true;
                            allValuesEntered = updateinput(inputx, inputy, inputz, inputc, NumofChar, allValuesEntered);
                            _Calculate();
                          });
                        }
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: Zaxiscontrollers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Z-axis',
                        ),
                        onChanged: (value) {
                          setState(() {
                            axisValues[index].z = double.tryParse(value) ?? 0.0;
                            inputz[index] = true;
                            allValuesEntered = updateinput(inputx, inputy, inputz, inputc, NumofChar, allValuesEntered);
                            _Calculate();
                          });
                        }
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: Chargecontrollers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Charge/nC',
                        ),
                        onChanged: (value) {
                          setState(() {
                            Chargevalues[index] = double.tryParse(value) ?? 0.0;
                            inputc[index] = true;
                            allValuesEntered = updateinput(inputx, inputy, inputz, inputc, NumofChar, allValuesEntered);
                            _Calculate();
                          });
                        }
                      ),
                    ),
                  ),
                  if (index == 0)
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: (inputc[5] && inputx[5] && inputy[5] && inputz[5]) ? (){
                        setState(() {_addNewRow(); allValuesEntered = false; _Calculate();});
                      }: null,
                    ),
                  if (index > 0)
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          Chargecontrollers.removeAt(index);
                          Xaxiscontrollers.removeAt(index);
                          Yaxiscontrollers.removeAt(index);
                          Zaxiscontrollers.removeAt(index);
                          Chargevalues.removeAt(index);
                          axisValues.removeAt(index);
                          dValues.removeAt(index);
                          distancesR.removeAt(index);
                          Evectors.removeAt(index);
                          inputc[index] = false;
                          inputx[index] = false;
                          inputy[index] = false;
                          inputz[index] = false;
                          NumofChar--;
                          _Calculate();
                        });
                      },
                    ),
                ],
              );
            },
          ),
          if(allValuesEntered)
          Padding(
            padding: const EdgeInsets.all(8.0), 
            child: 
            ExpansionTile(
              title: Math.tex(
                r"\begin{aligned}" +
                r"&\mathrm{Total\,E-field\,@\,source\,is:\,}{\vec{E}}_{total}=" + _seperateDouble(axisE.x) + "\\vec{a_x}+" + _seperateDouble(axisE.y) + "\\vec{a_y}+" + _seperateDouble(axisE.z) + "\\vec{a_z}\\\\" + 
                r"&\mathrm{E-force\,for\,source\,charge\,is:\,}\vec{F}=" + _seperateDouble(axisF.x) + "\\vec{a_x}+" + _seperateDouble(axisF.y) + "\\vec{a_y}+" + _seperateDouble(axisF.z) + "\\vec{a_z}" +
                r"\end{aligned}"
              ),
              leading: Icon(Icons.check, color: Colors.blue[900],),
              collapsedBackgroundColor: Colors.lightBlue[50],
              //backgroundColor: Colors.white,
              childrenPadding: EdgeInsets.zero,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(children: [
                    SizedBox(height: 10.0,),
                    Text("Step 1: Write the source charge in vector", style: TextStyle(decoration: TextDecoration.underline),),
                    Math.tex(r"\mathrm{Source\,vector:}\vec{s}=" + "${source.x}" + "\\vec{a_x}+" + "${source.y}" + "\\vec{a_y}+" + "${source.z}" + "\\vec{a_z}" ),
                    SizedBox(height: 10.0,),
                    Text("Step 2: Write field charges in vector", style: TextStyle(decoration: TextDecoration.underline),),
                    for(int k=0; k<NumofChar; k++)...{
                      Math.tex(r"\mathrm{Field\,vector\," + "${k+1}" + ":}\\vec{f_1}=" + "${axisValues[k].x}" + "\\vec{a_x}+" + "${axisValues[k].y}" + "\\vec{a_y}+" + "${axisValues[k].z}" + "\\vec{a_z}" ),
                    },
                    SizedBox(height: 10.0,),
                    Text("Step 3: Calculate distance vectors between source and field charges", style: TextStyle(decoration: TextDecoration.underline),),
                    for(int k=0; k<NumofChar; k++)...{
                      Math.tex(
                        r"\begin{aligned}" + 
                        r"\mathrm{Distance\,vector\," + "${k+1}" + ":}\\vec{R_" + "${k+1}" + "}" +
                        r"&=\vec{f_" + "${k+1}" + " }-\\vec{s}\\\\" +
                        r"&=(" + "${axisValues[k].x}" + "\\vec{a_x}+" + "${axisValues[k].y}" + "\\vec{a_y}+" + "${axisValues[k].z}" + "\\vec{a_z}" + ")-(" + "${source.x}" + "\\vec{a_x}+" + "${source.y}" + "\\vec{a_y}+" + "${source.z}" + "\\vec{a_z})\\\\" +
                        r"&=(" + "${axisValues[k].x}" + "-" + "${source.x}" + ")\\vec{a_x}+(" + "${axisValues[k].y}" + "-" + "${source.y}" + ")\\vec{a_y}+(" + "${axisValues[k].z}" + "-" + "${source.z}" + ")\\vec{a_z}\\\\"
                        r"&=" + "${dValues[k].x}" + "\\vec{a_x}+" + "${dValues[k].y}" + "\\vec{a_y}+" + "${dValues[k].z}" + "\\vec{a_z}"
                        r"\end{aligned}"
                      ),
                    },
                    SizedBox(height: 10.0,),
                    Text("Step 4: Calculate the distance between source and field charges", style: TextStyle(decoration: TextDecoration.underline),),
                    for(int k=0; k<NumofChar; k++)...{
                      Math.tex(r"\mathrm{Distance\," + "${k+1}" + ":R_" + "${k+1}" + "=}\\sqrt{" + "${dValues[k].x}" + "^2+" + "${dValues[k].y}" + "^2+" + "${dValues[k].z}" +"^2}=" + "${distancesR[k]}"),
                    },
                    SizedBox(height: 10.0,),
                    Text("Step 5: Calculate each E-field strength from field charges", style: TextStyle(decoration: TextDecoration.underline),),
                    for(int k=0; k<NumofChar; k++)...{
                      Math.tex(
                        r"\begin{aligned}" + 
                        r"\mathrm{E-field\,vector:} \vec{E_" + "${k+1}" + "}" +
                        r"&=\frac{Q_" + "${k+1}"+ "\\vec{R_" + "${k+1}"+ "}}{4\\pi \\epsilon R_" + "${k+1}" + "^3} \\\\" +
                        r"&=\frac{" + "${Chargevalues[k]}" + "}{4\\pi(8.854\\times10^{-12})}" + "\\frac{" + "${dValues[k].x}" + "\\vec{a_x}+" + "${dValues[k].y}" + "\\vec{a_y}+"+ "${dValues[k].z}" + "\\vec{a_z}}{" + "${distancesR[k]}" + "^3}\\\\" +
                        r"&=(" + _seperateDouble(Evectors[k].x) + ")\\vec{a_x}+(" +  "${_seperateDouble(Evectors[k].y)}" + ")\\vec{a_y}+(" + "${_seperateDouble(Evectors[k].z)}" + ")\\vec{a_z}"
                        r"\end{aligned}"
                      ),
                    },
                    SizedBox(height: 10.0,),
                    Text("Step 6: Calculate the total E-field strength from field charges", style: TextStyle(decoration: TextDecoration.underline),),
                    Math.tex(
                      r"\begin{aligned}" +
                      r"\mathrm{Total\,E-field:} {\vec{E}}_{total}" +
                      r"&=\sum_{i=1}^{" + "$NumofChar" + "}\\vec{E_i}\\\\" +
                      r"&=(" + _seperateDouble(axisE.x) + ")\\vec{a_x}+(" + _seperateDouble(axisE.y) + ")\\vec{a_y}+(" + _seperateDouble(axisE.z) + ")\\vec{a_z}\\\\" + 
                      r"&=E\vec{a_E}\\E" +
                      r"&=\sqrt{(" + _seperateDouble(axisE.x) + ")^2+(" + _seperateDouble(axisE.y) + ")^2+(" + _seperateDouble(axisE.z) + ")^2}=" + _seperateDouble(E) + "\\\\ \\vec{a_E}"
                      r"&=\frac{{\vec{E}}_{total}}{E}\\" +
                      r"&=\frac{(" + _seperateDouble(axisE.x) + ")\\vec{a_x}+(" +  _seperateDouble(axisE.y) + ")\\vec{a_y}+(" + _seperateDouble(axisE.z) + ")\\vec{a_z}" + "}{" + _seperateDouble(E) + "}\\\\" +
                      r"&=" + (Evector.x).toStringAsFixed(2) + "\\vec{a_x}+" + (Evector.y).toStringAsFixed(2)  + "\\vec{a_y}+" + (Evector.z).toStringAsFixed(2)  + "\\vec{a_z}" +
                      r"\end{aligned}"
                    ),
                    SizedBox(height: 10.0,),
                    Text("Final step: Multiply E-field strength and source charge to get E-force generated", style: TextStyle(decoration: TextDecoration.underline),),
                    Math.tex(r"\mathrm{E-force\,@\,source:}\vec{F}=Q_s{\vec{E}}_{total}=(" + _seperateDouble(axisF.x) + ")\\vec{a_x}+(" + _seperateDouble(axisF.y) + ")\\vec{a_y}+(" + _seperateDouble(axisF.z) + ")\\vec{a_z}"),
                    SizedBox(height: 20.0),
                  ],crossAxisAlignment: CrossAxisAlignment.start, ),
                ),
              
            // Text(
            //   'Charge Values are: ${Chargevalues.join(',')}' + ' X values are: ${Xvalues.join(',')}' + ' Y values are: ${Yvalues.join(',')}', 
            //   style: TextStyle(fontSize: 18),
            // ),
              ],
          ),),
        ],),//crossAxisAlignment: CrossAxisAlignment.start,),
      ), 
      

    );
  }

  @override
  void dispose() {
    for (var controller in Xaxiscontrollers) {controller.dispose();}
    for (var controller in Yaxiscontrollers) {controller.dispose();}
    for (var controller in Zaxiscontrollers) {controller.dispose();}
    for (var controller in Chargecontrollers) {controller.dispose();}
    super.dispose();
  }
}

class aVector {
  double x;
  double y;
  double z;

  aVector(this.x, this.y, this.z);

  @override
  String toString(){
    return '($x, $y, $z)';
  }
}