within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
record DataVAVMultiZone
  extends Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.Data;

  parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typSecRel
    "Relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes
    "Design of minimum outdoor air and economizer function"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.PressureDifference pAirSupSet_rel_max = 500
    "Duct design maximum static pressure"
    annotation (Dialog(group="Airflow and pressure",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_min(
    final min=2.4, start=10) = 10
    "Return fan minimum discharge static pressure set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_max(
    final min=10, start=100) = 100
    "Return fan maximum discharge static pressure set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

  parameter Real ySpeFanSup_min(final unit="1", final min=0, final max=1, start=0.1)= 0.1
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(group="Airflow and pressure",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
    typFanSup<>Buildings.Templates.Components.Types.Fan.None));

  parameter Real ySpeFanRel_min(final unit="1", final min=0, final max=1, start=0.1)=0.1
    "Minimum relief fan speed"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typFanRel<>Buildings.Templates.Components.Types.Fan.None));

  parameter Real ySpeFanRet_min(final unit="1", final min=0, final max=1, start=0.1)=0.1
    "Minimum return fan speed"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typFanRet<>Buildings.Templates.Components.Types.Fan.None));

  parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal=15
    "Design minimum outdoor air damper differential pressure"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      minOADes==Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP));

  parameter Modelica.Units.SI.PressureDifference pAirBuiSet_rel(start=12)=12
    "Building static pressure set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
       or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
       or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)));

  parameter Modelica.Units.SI.VolumeFlowRate dVFanRet_flow=0.1
    "Airflow differential between supply and return fans to maintain building pressure at set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir));

  parameter Real nPeaSys_nominal(final unit="1", final min=0)=100
    "Design system population (including diversity)"
    annotation (Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirSupSet_min(
    displayUnit="degC")=13+273.15
    "Lowest supply air temperature set point"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirSupSet_max(
    displayUnit="degC")=18+273.15
    "Highest supply air temperature set point"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirOutRes_min(
    displayUnit="degC")=16+273.15
    "Lowest value of the outdoor air temperature reset range"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirOutRes_max(
    displayUnit="degC")=21+273.15
    "Highest value of the outdoor air temperature reset range"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));


end DataVAVMultiZone;
