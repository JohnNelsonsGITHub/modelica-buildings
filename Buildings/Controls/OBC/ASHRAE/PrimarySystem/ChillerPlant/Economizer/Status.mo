within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer;
block Status "Water side economizer enable/disable status"

  parameter Modelica.SIunits.Time holdPeriod=20*60
  "Water side economizer (WSE) minimum on or off time";

  parameter Modelica.SIunits.TemperatureDifference TOffsetEna=2
  "Temperature offset between the chilled water return upstream of WSE and the predicted WSE output";

  parameter Modelica.SIunits.TemperatureDifference TOffsetDis=1
  "Temperature offset between the chilled water return upstream and downstream of WSE";

  parameter Modelica.SIunits.TemperatureDifference heaExcAppDes=2
  "Design heat exchanger approach"
    annotation(Dialog(group="Design parameters"));

  parameter Modelica.SIunits.TemperatureDifference cooTowAppDes=2
  "Design cooling tower approach"
    annotation(Dialog(group="Design parameters"));

  parameter Modelica.SIunits.Temperature TOutWetDes=288.15
  "Design outdoor air wet bulb temperature"
    annotation(Dialog(group="Design parameters"));

  parameter Real VHeaExcDes_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.015
    "Desing heat exchanger water volume flow rate"
    annotation(Dialog(group="Design parameters"));

  parameter Real step=0.02 "Tuning step"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Tuning"));

  parameter Modelica.SIunits.Time ecoOnTimDec = 60*60
  "Economizer enable time needed to allow decrease of the tuning parameter"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Tuning"));

  parameter Modelica.SIunits.Time ecoOnTimInc = 30*60
  "Economizer enable time needed to allow increase of the tuning parameter"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Tuning"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the water side economizer"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatWseDow
    "Chiller water return temperature downstream of the water side economizer"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpe
    "Water side economizer tower fan speed"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{160,-10},{180,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Tuning wseTun(
    final step=step,
    final ecoOnTimDec=ecoOnTimDec,
    final ecoOnTimInc=ecoOnTimInc)
    "Tuning parameter for the WSE outlet temperature calculation"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.PredictedOutletTemperature wseTOut(
    final heaExcAppDes=heaExcAppDes,
    final cooTowAppDes=cooTowAppDes,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow)
    "Calculates the predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater greEna "Enable condition"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater greDis "Disable condition"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant addTOffsetEna(
    final k=TOffsetEna)
    "Temperature offset for enable conditions"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Adder"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Logical pre"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1) "Adder"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant addTOffsetDis(
    final k=TOffsetDis)
    "Additional temperature offset"
    annotation (Placement(transformation(extent={{-60,-62},{-40,-42}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=holdPeriod,
    final falseHoldDuration=holdPeriod)
    "Keeps a signal constant for a given time period"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not"
    annotation (Placement(transformation(extent={{50,0},{70,20}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));

equation
  connect(addTOffsetEna.y, add2.u2)
    annotation (Line(points={{-39,10},{-30,10},{-30,24},{-22,24}},color={0,0,127}));
  connect(add2.y, greEna.u2)
    annotation (Line(points={{1,30},{10,30},{10,42},{18,42}}, color={0,0,127}));
  connect(TChiWatRet, greEna.u1)
    annotation (Line(points={{-180,60},{-120,60},{-120,80},{10,80},{10,50},{18,50}},
    color={0,0,127}));
  connect(uTowFanSpe, wseTun.uTowFanSpe)
    annotation (Line(points={{-180,-100},{-132,-100},{-132,-105},{-122,-105}},
    color={0,0,127}));
  connect(wseTun.yTunPar, wseTOut.uTunPar)
    annotation (Line(points={{-99,-100},{-90,-100},{-90,42},{-82,42}},color={0,0,127}));
  connect(TOutWet, wseTOut.TOutWet)
    annotation (Line(points={{-180,100},{-100,100},{-100,58},{-82,58}},color={0,0,127}));
  connect(wseTOut.TEcoOut_pred, add2.u1)
    annotation (Line(points={{-58,50},{-40,50},{-40,36},{-22,36}},color={0,0,127}));
  connect(VChiWat_flow, wseTOut.VChiWat_flow)
    annotation (Line(points={{-180,-40},
          {-100,-40},{-100,50},{-82,50}}, color={0,0,127}));
  connect(pre.y, wseTun.uEcoSta)
    annotation (Line(points={{141,-50},{150,-50},{150,
          -80},{-132,-80},{-132,-95},{-122,-95}},     color={255,0,255}));
  connect(TChiWatRet, add1.u1)
    annotation (Line(points={{-180,60},{-130,60},{-130,
          -24},{-22,-24}}, color={0,0,127}));
  connect(add1.y, greDis.u2)
    annotation (Line(points={{1,-30},{8,-30},{8,-18},{18,
          -18}}, color={0,0,127}));
  connect(addTOffsetDis.y, add1.u2)
    annotation (Line(points={{-39,-52},{-32,-52},
          {-32,-36},{-22,-36}}, color={0,0,127}));
  connect(TChiWatWseDow, greDis.u1)
    annotation (Line(points={{-180,20},{-140,20},
          {-140,-10},{18,-10}}, color={0,0,127}));
  connect(truFalHol.y, pre.u)
    annotation (Line(points={{121,20},{140,20},{140,-30},
          {108,-30},{108,-50},{118,-50}}, color={255,0,255}));
  connect(truFalHol.y, yEcoSta)
    annotation (Line(points={{121,20},{140,20},{140,
          0},{170,0}}, color={255,0,255}));
  connect(greDis.y, not1.u)
    annotation (Line(points={{41,-10},{44,-10},{44,10},{
          48,10}}, color={255,0,255}));
  connect(greEna.y, and2.u1)
    annotation (Line(points={{41,50},{68,50}}, color={255,0,255}));
  connect(truFalHol.u, and2.y)
    annotation (Line(points={{99,20},{96,20},{96,50},{91,50}}, color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{71,10},{80,10},{80,32},{60,
          32},{60,42},{68,42}}, color={255,0,255}));
  annotation (defaultComponentName = "wseSta",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-120},{160,120}})),
Documentation(info="<html>
<p>
Waterside economizer (WSE) sequence per OBC Chilled Water Plant Sequence of Operation
document, section 3.2.3. It consists of a subsequence predicting the WSE outlet
temperature at given conditions (3.2.3.1.), a subsequence defining the temperature prediction
tuning parameter (3.2.3.2.) and enable/disable conditions (3.2.3.1. and 3.2.3.2.).
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Status;