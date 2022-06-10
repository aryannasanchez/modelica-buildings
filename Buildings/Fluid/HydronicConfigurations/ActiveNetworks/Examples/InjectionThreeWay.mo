within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionThreeWay
  "Model illustrating the operation of an inversion circuit with three-way valve"
  extends BaseClasses.PartialActivePrimary(
    m1_flow_nominal=
      m2_flow_nominal * (TLiqEnt_nominal - TLiqLvg_nominal) / (TLiqSup_nominal - TLiqLvg_nominal),
    kSizPum=5.0,
    TLiqEnt_nominal=40+273.15,
    TLiqLvg_nominal=TLiqEnt_nominal-5,
    dpPum_nominal=(dpPip_nominal + dpValve_nominal) * kSizPum,
    del1(nPorts=2));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa")=0.3E4
    "Control valve pressure drop at design conditions";

  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionThreeWay con(
    have_ctl=true,
    typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant,
    redeclare final package Medium = MediumLiq,
    use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp2_nominal=dpTer_nominal + loa.con.dpValve_nominal + dpPip_nominal,
    final dpBal1_nominal= if is_bal then dpPum_nominal - dpPip_nominal - dpValve_nominal
      else 0)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl
    loa(
    redeclare final package MediumLiq = MediumLiq,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(table=[0,0,0;
        6,0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,
        1; 22,0,0; 24,0,0],
    timeScale=3600)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl
    loa1(
    redeclare final package MediumLiq = MediumLiq,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Sensors.RelativePressure dp(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=con.pum.m_flow_nominal - loa.mLiq_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mod(
    table=[0,0; 6,0; 6,
        1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable setOff(table=[0,0; 12,
        0; 13,-5; 14,-7; 17,0; 24,0],  timeScale=3600)
    "Offset applied to design supply temperature to compute set point"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter T2Set(final p=
        TLiqEnt_nominal, y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature set point" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,60})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal rea
    "Convert signal into real"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-18,-20})));
  Buildings.Controls.OBC.CDL.Integers.Min min
    "Min with 1"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-20})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "One"
    annotation (Placement(transformation(extent={{-100,-36},{-80,-16}})));
equation
  connect(con.port_b1, dp.port_b) annotation (Line(points={{36,0},{36,-10},{40,-10},
          {40,-40}}, color={0,127,255}));
  connect(con.port_a1, dp.port_a) annotation (Line(points={{24,0},{24,-10},{20,-10},
          {20,-40}}, color={0,127,255}));
  connect(res2.port_b, loa1.port_a) annotation (Line(points={{90,50},{100,50},{100,
          70}},         color={0,127,255}));
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-78,100},{20,100},{20,76},
          {38,76}}, color={0,0,127}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-78,100},{80,100},{80,76},
          {98,76}}, color={0,0,127}));
  connect(setOff.y[1], T2Set.u)
    annotation (Line(points={{-78,60},{-62,60}}, color={0,0,127}));
  connect(mod.y[1], con.mod) annotation (Line(points={{-78,20},{10,20},{10,18},{
          18,18}},                   color={255,127,0}));
  connect(T2Set.y, con.set) annotation (Line(points={{-38,60},{0,60},{0,6},{18,
          6}},      color={0,0,127}));
  connect(min.y, rea.u)
    annotation (Line(points={{-38,-20},{-30,-20}},
                                               color={255,127,0}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{24,20},{24,50},{40,
          50},{40,70}}, color={0,127,255}));
  connect(loa.port_b, con.port_a2)
    annotation (Line(points={{60,70},{60,19.8},{36,19.8}},
                                                         color={0,127,255}));
  connect(con.port_b2,res2. port_a)
    annotation (Line(points={{24,20},{24,50},{70,50}},
                                                     color={0,127,255}));
  connect(loa1.port_b, con.port_a2)
    annotation (Line(points={{120,70},{120,19.8},{36,19.8}},
                                                           color={0,127,255}));
  connect(res1.port_b, dp.port_a) annotation (Line(points={{10,-60},{20,-60},{20,
          -40}},    color={0,127,255}));
  connect(dp.port_b, del1.ports[2])
    annotation (Line(points={{40,-40},{40,-80}},  color={0,127,255}));
  connect(rea.y, pum.y) annotation (Line(points={{-6,-20},{0,-20},{0,-40},{-60,
          -40},{-60,-48}},   color={0,0,127}));
  connect(mod.y[1], min.u1) annotation (Line(points={{-78,20},{-70,20},{-70,-14},
          {-62,-14}}, color={255,127,0}));
  connect(one.y, min.u2)
    annotation (Line(points={{-78,-26},{-62,-26}}, color={255,127,0}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionThreeWay.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of an injection circuit with a three-way valve
that serves as the interface between a constant flow primary circuit at constant
supply temperature and a constant flow secondary circuit at variable supply
temperature.
Two identical terminal units circuits are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without
considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
</ul>

</html>"));
end InjectionThreeWay;
