within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoolingCoilEffectivenessNTU3WayValve
  extends VAVSingleDuct(
    redeclare replaceable record RecordCoiCoo = Coils.Data.WaterBased (
      redeclare
        Buildings.Templates.AHUs.Coils.HeatExchangers.Data.EffectivenessNTU
        datHex, redeclare
        Buildings.Templates.AHUs.Coils.Actuators.Data.ThreeWayValve
        datAct),
    redeclare Coils.WaterBased coiCoo(redeclare
      Buildings.Templates.AHUs.Coils.Actuators.ThreeWayValve
      act, redeclare
      Buildings.Templates.AHUs.Coils.HeatExchangers.EffectivenessNTU
      coi));
  annotation (
    defaultComponentName="ahu");
end CoolingCoilEffectivenessNTU3WayValve;