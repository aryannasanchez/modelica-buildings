within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model VAVMultiZoneOpenLoop
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaPre(
        redeclare final package MediumHea = MediumHea,
        redeclare replaceable
        Buildings.Templates.Components.Valves.TwoWayModulating val),
    redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Economizer
      secOutRel(redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
        secOut "Single common OA damper (modulating) with AFMS", redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
        secRel "Return fan with modulating relief damper"),
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
      redeclare final package MediumCoo = MediumCoo,
      redeclare replaceable
        Buildings.Templates.Components.Valves.TwoWayModulating val)
      "Chilled water coil",
    redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable
      fanSupDra);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneOpenLoop;
