let
  option_type = o: o.type;
  option_description = o: o.description or "";
  loc = o: o.loc or [];
in { inherit option_type option_description loc; }
