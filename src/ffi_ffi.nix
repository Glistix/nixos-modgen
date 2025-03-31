let
  identity = x: x;
  get_lib_obj_type = x: x._type or "";
in { inherit identity get_lib_obj_type; }
