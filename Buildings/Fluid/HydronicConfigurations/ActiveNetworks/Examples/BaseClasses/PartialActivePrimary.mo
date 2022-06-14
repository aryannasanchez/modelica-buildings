within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
model PartialActivePrimary
  "Partial model of an active primary network"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";

  parameter Buildings.Fluid.HydronicConfigurations.Types.ControlFunction typ=
    Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating
    "Load type"
    annotation(Evaluate=true);

  parameter Integer nTer=2
    "Number of terminal units";
  parameter Modelica.Units.SI.MassFlowRate mTer_flow_nominal = 1
    "Terminal unit mass flow rate at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(final min=0)=
    m2_flow_nominal
    "Mass flow rate in primary branch at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(final min=0)=
    nTer * mTer_flow_nominal
    "Mass flow rate in consumer circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpTer_nominal(displayUnit="Pa")=
     3E4
    "Terminal unit pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpPip_nominal(displayUnit="Pa")=
     0.5E4
    "Pipe section pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Real kSizPum(unit="1")=1.0
    "Pump oversizing coefficient";
  parameter Modelica.Units.SI.PressureDifference dpPum_nominal(
    final min=0,
    displayUnit="Pa")
    "Pump head at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal=m1_flow_nominal
    "Primary pump mass flow rate at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Pressure p_min=200000
    "Circuit minimum pressure";

  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=
    if typ==Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating
      then 60+273.15 else 7+273.15
    "Liquid entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=TLiqEnt_nominal+(
    if typ==Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating
      then -10 else +5)
    "Liquid leaving temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqSup_nominal=TLiqEnt_nominal
    "Liquid primary supply temperature at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    final T=TLiqSup_nominal,
    nPorts=2)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,-90})));
  Movers.SpeedControlled_y pum(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    addPowerToMedium=false,
    use_inputFilter=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    per(pressure(V_flow={0,1,2}*mPum_flow_nominal/996, dp={1.2,1,0.4}*
            dpPum_nominal)),
    inputType=Buildings.Fluid.Types.InputType.Continuous)
    "Circulation pump"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    final dp_nominal=dpPip_nominal) "Pipe pressure drop"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    final tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
         then 0 else 1,
    T_start=TLiqSup_nominal)
    "Return temperature sensor"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-40,-80})));
  Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    final tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
         then 0 else 1,
    T_start=TLiqSup_nominal)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-60,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract  delT(y(final unit="K"))
    "Primary delta-T"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-110})));
  Delays.DelayFirstOrder del1(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mPum_flow_nominal,
    nPorts=1)
    "Fluid transport delay"
    annotation (Placement(transformation(extent={{10,-80},{30,-100}})));
equation
  connect(pum.port_b,TSup. port_a)
    annotation (Line(points={{-70,-60},{-70,-60}}, color={0,127,255}));
  connect(TSup.port_b,res1. port_a)
    annotation (Line(points={{-50,-60},{-30,-60}}, color={0,127,255}));
  connect(TRet.T,delT. u1)
    annotation (Line(points={{-40,-91},{-40,-98},{-44,-98}},color={0,0,127}));
  connect(TSup.T,delT. u2)
    annotation (Line(points={{-60,-71},{-60,-98},{-56,-98}},color={0,0,127}));

  connect(ref.ports[1], pum.port_a) annotation (Line(points={{-81,-80},{-100,-80},
          {-100,-60},{-90,-60}},  color={0,127,255}));
  connect(ref.ports[2], TRet.port_b)
    annotation (Line(points={{-79,-80},{-50,-80}},   color={0,127,255}));
  connect(TRet.port_a, del1.ports[1])
    annotation (Line(points={{-30,-80},{20,-80}},   color={0,127,255}));
  annotation (
  Diagram(
      coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end PartialActivePrimary;
