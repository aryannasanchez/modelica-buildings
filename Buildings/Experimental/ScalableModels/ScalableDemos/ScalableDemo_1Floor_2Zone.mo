within Buildings.Experimental.ScalableModels.ScalableDemos;
model ScalableDemo_1Floor_2Zone
  extends
    Buildings.Experimental.ScalableModels.ScalableBuildingModels.MultiFloorWithVAV(
     nFlo=1, nZon=2);

annotation (
  experiment(StopTime=604800, Tolerance=1e-06,__Dymola_Algorithm="Radau"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/ScalableModels/ScalableDemos/ScalableDemo_1Floor_2Zone.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-120},{140,200}})),
  Documentation(info="<html>
<p>
The model demonstrates the scalability of model 
<a href=\"modelica://Buildings.Experimental.ScalableModels.ScalableBuildingModels.MultiFloorWithVAV\">
Buildings.Experimental.ScalableModels.ScalableBuildingModels.MultiFloorWithVAV</a> 
by setting it to be a multizone model of 2 zones in 1 floor, i.e.
<code>nFlo=1, nZon=2</code>.
</p></html>", revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScalableDemo_1Floor_2Zone;
