within Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus;
model Large4Floors
  "Model of a large building with 4 floors and 15 conditioned zones"
  extends
    Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus.Large2Floors(      final numFlo=4);

    annotation (
experiment(
      StopTime=432000,
      Tolerance=1e-05),
Documentation(info="<html>
<p>
Example model of a large office building with 20 thermal zones
that are supplied by 4 multizone VAV air handling units.<br/>
The thermal zones are modeled using
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.ThermalZone\">
Buildings.ThermalZones.EnergyPlus.ThermalZone</a> objects.
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end Large4Floors;
