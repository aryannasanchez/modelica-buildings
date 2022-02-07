within Buildings.Fluid.Storage.Plant.Examples;
model ChillerAndTankNoRemoteCharging "(Draft)"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.Storage.Plant.ChillerAndTankNoRemoteCharging cat(
    redeclare final package Medium=Medium,
    final m1_flow_nominal=1,
    final m2_flow_nominal=1,
    final p_CHWS_nominal=sin.p,
    final p_CHWR_nominal=sou.p,
    final T_CHWS_nominal=sin.T,
    final T_CHWR_nominal=sou.T)
    "Plant with chiller and tank"
    annotation (Placement(transformation(extent={{-16,-10},{16,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    p=300000,
    T=285.15,
    nPorts=1)
    "Source representing CHW return line"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,0})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    p=800000,
    T=280.15,
    nPorts=1)
    "Sink representing CHW supply line"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={60,0})));
  Modelica.Blocks.Sources.TimeTable setFloPum2(table=[0*3600,1; 0.25*3600,1;
        0.25*3600,-1; 0.5*3600,-1; 0.5*3600,0; 0.75*3600,0; 0.75*3600,1; 1*3600,
        1]) "Placeholder"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Modelica.Blocks.Sources.Constant set_mChi_flow(k=cat.m1_flow_nominal)
    "Prescribed chiller branch flow rate"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
equation
  connect(sou.ports[1], cat.port_a)
    annotation (Line(points={{-50,0},{-16,0}}, color={0,127,255}));
  connect(cat.port_b, sin.ports[1]) annotation (Line(points={{16,0},{33,0},{33,4.44089e-16},
          {50,4.44089e-16}}, color={0,127,255}));

  connect(setFloPum2.y, cat.usMasFloPum2) annotation (Line(points={{-49,30},{
          -22,30},{-22,6},{-17.6,6}},
                                    color={0,0,127}));
  connect(set_mChi_flow.y, cat.us_mChi_flow) annotation (Line(points={{-49,70},
          {-4.8,70},{-4.8,11}},  color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end ChillerAndTankNoRemoteCharging;