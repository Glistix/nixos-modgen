let
  name = typ: typ.name;
  check = typ: val: typ.check val;
  description = typ: typ.description or "";
in { inherit name check description; }
