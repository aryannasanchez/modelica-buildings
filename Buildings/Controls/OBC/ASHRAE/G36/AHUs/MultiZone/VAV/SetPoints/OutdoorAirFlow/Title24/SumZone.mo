within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24;
block SumZone "Sum of the zone level setpoints calculation"

  parameter Integer nZon
    "Total number of serving zones";
  parameter Integer nZonGro
    "Total number of zone group";
  parameter Integer zonGroMat[nZonGro, nZon]
    "Zone matrix with zone group as row index and zone as column index. It falgs which zone is grouped in which zone group";
  parameter Integer zonGroMatTra[nZon, nZonGro]
    "Transpose of the zone matrix";
  parameter Boolean have_CO2Sen
    "True: there are zones have CO2 sensor";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod[nZonGro]
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VZonAbsMin_flow[nZon](
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VZonDesMin_flow[nZon](
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCO2[nZon](
    final unit="1") if have_CO2Sen
    "Zone CO2 control loop"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumZonAbsMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{120,20},{160,60}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumZonDesMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{120,-50},{160,-10}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxCO2(
    final unit="1")
    if have_CO2Sen
    "Maximum CO2 control loop signal"
    annotation (Placement(transformation(extent={{120,-120},{160,-80}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo(
    final K=zonGroMat)
    "Vector of total zone flow of each group"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo1(
    final K=zonGroMat)
    "Vector of total zone flow of each group"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nZonGro]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nZonGro]
    "Find the total flow of zone group"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1[nZonGro]
    "Find the total flow of zone group"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=nZonGro)
    "Sum of the zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(
    final nin=nZonGro)
    "Sum of the zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod[nZonGro](
    final k=fill(Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied,nZonGro))
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nZonGro]
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    final nin=nZon) if have_CO2Sen
    "Maximum CO2 loop signal"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));

equation
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-140,100},{-42,100}},  color={255,127,0}));
  connect(occMod.y, intEqu1.u2) annotation (Line(points={{-78,60},{-60,60},{-60,
          92},{-42,92}},         color={255,127,0}));
  connect(VZonAbsMin_flow, groFlo.u)
    annotation (Line(points={{-140,20},{-102,20}}, color={0,0,127}));
  connect(intEqu1.y, booToRea.u)
    annotation (Line(points={{-18,100},{-2,100}},  color={255,0,255}));
  connect(groFlo.y, mul.u2) annotation (Line(points={{-78,20},{-60,20},{-60,34},
          {38,34}},       color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{22,100},{30,100},{30,46},
          {38,46}},  color={0,0,127}));
  connect(booToRea.y, mul1.u1) annotation (Line(points={{22,100},{30,100},{30,-24},
          {38,-24}}, color={0,0,127}));
  connect(groFlo1.y, mul1.u2) annotation (Line(points={{-78,-50},{-60,-50},{-60,
          -36},{38,-36}}, color={0,0,127}));
  connect(mul.y, mulSum.u)
    annotation (Line(points={{62,40},{78,40}},   color={0,0,127}));
  connect(mul1.y, mulSum1.u)
    annotation (Line(points={{62,-30},{78,-30}}, color={0,0,127}));
  connect(VZonDesMin_flow, groFlo1.u)
    annotation (Line(points={{-140,-50},{-102,-50}}, color={0,0,127}));
  connect(mulSum.y, VSumZonAbsMin_flow)
    annotation (Line(points={{102,40},{140,40}}, color={0,0,127}));
  connect(mulSum1.y, VSumZonDesMin_flow)
    annotation (Line(points={{102,-30},{140,-30}}, color={0,0,127}));
  connect(uCO2, mulMax.u)
    annotation (Line(points={{-140,-100},{38,-100}}, color={0,0,127}));
  connect(mulMax.y, yMaxCO2)
    annotation (Line(points={{62,-100},{140,-100}}, color={0,0,127}));
annotation (
  defaultComponentName="sumZon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,38},{-26,22}},
          lineColor={0,0,0},
          textString="VZonAbsMin_flow"),
        Text(
          extent={{-96,-22},{-26,-38}},
          lineColor={0,0,0},
          textString="VZonDesMin_flow"),
        Text(
          extent={{-96,86},{-52,72}},
          lineColor={255,127,0},
          textString="uOpeMod"),
        Text(
          extent={{26,48},{98,32}},
          lineColor={0,0,0},
          textString="VSumZonAbsMin_flow"),
        Text(
          extent={{26,-30},{98,-46}},
          lineColor={0,0,0},
          textString="VSumZonDesMin_flow"),
        Text(
          extent={{-96,-72},{-66,-86}},
          lineColor={0,0,0},
          textString="uCO2",
          visible=have_CO2Sen),
        Text(
          extent={{66,-80},{96,-94}},
          lineColor={0,0,0},
          textString="yMaxCO2",
          visible=have_CO2Sen)}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
Documentation(info="<html>
<p>
This sequence sums up zone level minimum outdoor airflow setpoints when complying
with California Title 24 ventilation requirements. It is implemented according
to Section 5.16.3.2 of ASHRAE Guideline G36, May 2020.
</p>
<p>
It calculates following values:
</p>
<ol>
<li>
Sum of the zone absolute minimum outdoor airflow setpoint <code>VZonAbsMin_flow</code>
for all zones in all zone groups that are in occupied mode.
</li>
<li>
Sum of the zone design minimum outdoor airflow setpoint <code>VZonDesMin_flow</code>
for all zones in all zone groups that are in occupied mode.
</li>
<li>
Maximum zone level CO2 control loop signal <code>yMaxCO2</code>.
</li>
</ol>
<p>
See the zone absolute and design minimum outdoor airflow setpoint
<code>VZonAbsMin_flow</code> and <code>VZonDesMin_flow</code> from
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints</a> for the detailed
description.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SumZone;