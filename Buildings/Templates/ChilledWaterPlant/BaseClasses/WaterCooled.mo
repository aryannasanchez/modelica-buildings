within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model WaterCooled
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
    final is_airCoo=false,
    chiGro(redeclare final package MediumCW = MediumCW),
    con(final nPumCon=nPumCon, final nCooTow=nCooTow));

  replaceable package MediumCW=Buildings.Media.Water "Condenser water medium";

  final parameter Integer nPumCon = pumCon.nPum "Number of condenser pumps";
  final parameter Integer nCooTow = cooTow.nCooTow "Number of cooling towers";

  final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=
    dat.getReal(varName=id + ".CondenserWater.m_flow_nominal.value")
    "Condenser mass flow rate";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
    cooTow(final m_flow_nominal=mCon_flow_nominal)
           constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.CoolingTowerGroup(
      redeclare final package Medium = MediumCW)
    "Cooling tower group"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Headered
    pumCon(final has_WSE=not WSE.is_none,
    mTot_flow_nominal=mCon_flow_nominal,
    dp_nominal=dpCon_nominal)
           constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.CondenserWaterPumpGroup(
      redeclare final package Medium = MediumCW,
      final nChi=nChi)
    "Condenser water pump group"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Templates.Components.Sensors.Temperature TCWSup(
    redeclare final package Medium = MediumCW,
    final m_flow_nominal=mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Templates.Components.Sensors.Temperature TCWRet(
    redeclare final package Medium = MediumCW,
    final m_flow_nominal=mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Fluid.FixedResistances.Junction mixCW(
    redeclare package Medium = MediumCW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal={mCon_flow_nominal,0,mCon_flow_nominal})
    "Condenser water return mixer"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-90,-70})));

protected
  parameter Modelica.SIunits.PressureDifference dpCon_nominal=
    chiGro.dp1_nominal + cooTow.dp_nominal
    "Nominal pressure drop for condenser loop";
equation
  connect(TCWRet.port_a, cooTow.port_a)
    annotation (Line(points={{-140,-70},{-192,-70},{-192,-10},{-180,-10}},
      color={0,127,255}));
  connect(cooTow.port_b, TCWSup.port_a)
    annotation (Line(points={{-160,-10},{-140,-10}}, color={0,127,255}));
  connect(TCWSup.port_b,pumCon. port_a)
    annotation (Line(points={{-120,-10},{-100,-10}}, color={0,127,255}));
  connect(TCWRet.port_b, mixCW.port_1)
    annotation (Line(points={{-120,-70},{-100,-70}}, color={0,127,255}));
  connect(pumCon.port_wse, WSE.port_a1)
    annotation (Line(points={{-80,-16},{-70,-16},{-70,-50},{-46,-50},{-46,-62}},
      color={0,127,255}));
  connect(chiGro.port_b1, mixCW.port_3)
    annotation (Line(points={{-46,0},{-46,-40},{-90,-40},{-90,-60}},
      color={0,127,255}));
  connect(pumCon.ports_b, chiGro.ports_a1)
    annotation (Line(points={{-80,-10},{-70,-10},{-70,30},{-46,30},{-46,20}},
      color={0,127,255}));
  connect(WSE.port_b1, mixCW.port_2)
   annotation (Line(points={{-46,-82},{-46,-88},{-70,-88},{-70,-70},{-80,-70}},
      color={0,127,255}));

  connect(weaBus, cooTow.weaBus);

  connect(TCWSup.y, cwCon.TCWSup);
  connect(TCWRet.y, cwCon.TCWRet);
  connect(cooTow.busCon, cwCon.cooTow);
  connect(pumCon.busCon, cwCon.pum);
end WaterCooled;