within Buildings.Templates.BaseClasses.OutdoorReliefReturnSection;
model HeatRecovery "Heat recovery"
  extends Templates.Interfaces.OutdoorReliefReturnSection(
    final typ=Templates.Types.OutdoorReliefReturnSection.HeatRecovery,
    final have_porPre=secRel.have_porPre,
    final typDamOut=secOut.typDamOut,
    final typDamOutMin=secOut.typDamOutMin,
    final typDamRel=secRel.typDam,
    final typFanRet=secRel.typFan);

  replaceable OutdoorSection.SingleCommon secOut
    constrainedby Templates.Interfaces.OutdoorSection(
      redeclare final package MediumAir = MediumAir,
      final have_recHea=true)
    "Outdoor air section"
    annotation (
    choices(
      choice(redeclare BaseClasses.OutdoorSection.SingleCommon secOut
        "Single common OA damper (modulated) with AFMS"),
      choice(redeclare BaseClasses.OutdoorSection.DedicatedAirflow secOut
        "Dedicated minimum OA damper (modulated) with AFMS"),
      choice(redeclare BaseClasses.OutdoorSection.DedicatedPressure secOut
        "Dedicated minimum OA damper (two-position) with differential pressure sensor")),
    Dialog(group="Outdoor air section"),
    Placement(transformation(extent={{-58,-94},{-22,-66}})));

  replaceable ReliefReturnSection.ReturnFan secRel
    constrainedby Templates.Interfaces.ReliefReturnSection(
      redeclare final package MediumAir = MediumAir,
      final have_recHea=true)
    "Relief/return air section"
    annotation (
      choices(
        choice(redeclare BaseClasses.ReliefReturnSection.ReturnFan secRel
          "Return fan - Modulated relief damper"),
        choice(redeclare BaseClasses.ReliefReturnSection.ReliefFan secRel
          "Relief fan - Two-position relief damper"),
        choice(redeclare BaseClasses.ReliefReturnSection.ReliefDamper secRel
          "No relief fan - Modulated relief damper")),
      Dialog(
        group="Exhaust/relief/return section"),
      Placement(transformation(extent={{-18,66},{18,94}})));

  replaceable Templates.BaseClasses.HeatRecovery.None none
    constrainedby Templates.Interfaces.HeatRecovery(
      redeclare final package MediumAir = MediumAir)
    "Heat recovery"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-50,-10},{-30,10}})));

equation
  connect(port_Rel, secRel.port_b)
    annotation (Line(points={{-180,80},{-18,80}}, color={0,127,255}));
  connect(secRel.port_a, port_Ret)
    annotation (Line(points={{18,80},{180,80}}, color={0,127,255}));
  connect(port_Out, secOut.port_a)
    annotation (Line(points={{-180,-80},{-58,-80}}, color={0,127,255}));
  connect(secOut.port_b, port_Sup)
    annotation (Line(points={{-22,-80},{180,-80}}, color={0,127,255}));
  connect(busCon, secRel.busCon) annotation (Line(
      points={{0,140},{0,94}},
      color={255,204,51},
      thickness=0.5));
  connect(secOut.busCon, busCon) annotation (Line(
      points={{-40,-66},{-40,-60},{-60,-60},{-60,120},{0,120},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,40},{
          80,40},{80,140}},               color={0,127,255}));
  connect(secRel.port_bHeaRec, none.port_aRel)
    annotation (Line(points={{-8,66},{-8,6},{-30,6}}, color={0,127,255}));
  connect(none.busCon, busCon) annotation (Line(
      points={{-40,10},{-40,120},{0,120},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(none.port_bRel, secRel.port_aHeaRec) annotation (Line(points={{-50,6},
          {-52,6},{-52,20},{-12,20},{-12,66}}, color={0,127,255}));
  connect(secOut.port_bHeaRec, none.port_aOut) annotation (Line(points={{-52,-66},
          {-52,-36},{-52,-6},{-50,-6}}, color={0,127,255}));
  connect(secOut.port_aHeaRec, none.port_bOut) annotation (Line(points={{-48,-66},
          {-48,-20},{-28,-20},{-28,-6},{-30,-6}}, color={0,127,255}));
end HeatRecovery;
