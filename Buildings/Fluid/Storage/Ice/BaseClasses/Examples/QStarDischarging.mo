within Buildings.Fluid.Storage.Ice.BaseClasses.Examples;
model QStarDischarging "Example to calculate QStarDischarging"
  extends Modelica.Icons.Example;
  parameter Real coeDisCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for discharging curve";
  parameter Real dt = 3600 "Time step used in the samples for curve fitting";

  Modelica.Blocks.Sources.Cosine fra(
    amplitude=0.5,
    f=1/86400,
    offset=0.5) "Fraction of charge"
    annotation (Placement(transformation(extent={{-60,-4},{-40,16}})));
  Modelica.Blocks.Sources.Constant lmtd(k=1) "Log mean temperature difference"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Storage.Ice.BaseClasses.QStarDischarging qSta(coeff=coeDisCha, dt=dt)
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  Controls.OBC.CDL.Logical.Sources.Constant active(k=true)
    "Outputs true to activate the component"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(fra.y, qSta.fraCha) annotation (Line(points={{-39,6},{-12,6}},
                    color={0,0,127}));
  connect(lmtd.y, qSta.lmtdSta) annotation (Line(points={{-39,-30},{-26,-30},{-26,
          -2},{-12,-2}}, color={0,0,127}));
  connect(active.y, qSta.active) annotation (Line(points={{-38,40},{-26,40},{
          -26,10},{-12,10}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StartTime=0,
              StopTime=86400,
              Tolerance=1e-06,
              __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/BaseClasses/Examples/QStarDischarging.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
    <p>This example is to validate the <a href=modelica://IceStorage.BaseClasses.QStar>QStar</a>.</p>
</html>", revisions="<html>
  <ul>
  <li>
  December 8, 2021, by Yangyang Fu:<br/>
  First implementation.
  </li>
  </ul>
</html>"));
end QStarDischarging;
