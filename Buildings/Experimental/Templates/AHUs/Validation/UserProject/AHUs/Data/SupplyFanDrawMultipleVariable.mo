within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record SupplyFanDrawMultipleVariable =
  Buildings.Experimental.Templates.AHUs.Data.VAVSingleDuct (
    redeclare Fans.Data.MultipleVariable datFanSup)
  annotation (
  defaultComponentName="datAhu");