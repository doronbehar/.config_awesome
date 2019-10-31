with import <nixpkgs> {};
pkgs.mkShell {
  GI_TYPELIB_PATH = "${playerctl}/lib/girepository-1.0";
  buildInputs = [
    (lua53Packages.lua.withPackages(ps: with ps; [
      lgi
    ]))
  ];
}
