with import <nixpkgs> {};
pkgs.mkShell {
  GI_TYPELIB_PATH = "${playerctl}/lib/girepository-1.0";
  buildInputs = [
    (luajitPackages.lua.withPackages(ps: with ps; [
      lgi
    ]))
  ];
}
