{ lib, fetchurl, stdenvNoCC, buildFHSEnv, makeDesktopItem }:

let
  version = "5.12.4";
  # Official Linux AMD64 stable release, revision 34645. SHA-512 published at
  # https://download.slicer.org/ (Checksums, Linux).
  src = fetchurl {
    url = "https://download.slicer.org/bitstream/6aa1beb7ce9de556d3010204";
    name = "Slicer-${version}-linux-amd64.tar.gz";
    hash = "sha512-rHbFBhqP/yDU5ZcyhV90Ngkw/UiRRQCFvLxqjrGh9K3pocpPxjMUJmG3FNvoxGBDBgeflUblIFP6peb5lBDPdg==";
  };
  payload = stdenvNoCC.mkDerivation {
    pname = "3d-slicer-unwrapped";
    inherit version src;
    # Preserve upstream's bundled ELF RPATHs and Python library layout.
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/slicer
      cp -a . $out/opt/slicer/
      runHook postInstall
    '';
  };
  desktop = makeDesktopItem {
    name = "3d-slicer";
    desktopName = "3D Slicer";
    comment = "Medical image visualization and analysis";
    exec = "3d-slicer";
    categories = [ "Science" "MedicalSoftware" ];
    terminal = false;
  };
in
buildFHSEnv {
  name = "3d-slicer";
  inherit version;
  targetPkgs = pkgs: with pkgs; [
    alsa-lib dbus expat fontconfig freetype glib libGL libGLU libxkbcommon
    nss nspr openssl pcre2 libpulseaudio udev zlib
    libice libsm libx11 libxcomposite libxcursor libxdamage libxext libxfixes
    libxi libxrandr libxrender libxt libxtst libxcb
    xcbutil xcbutilcursor xcbutilimage xcbutilkeysyms xcbutilrenderutil xcbutilwm
  ];
  runScript = "${payload}/opt/slicer/Slicer";
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    ln -s ${desktop}/share/applications/3d-slicer.desktop $out/share/applications/
  '';
  meta = {
    description = "Medical image visualization and analysis";
    homepage = "https://www.slicer.org/";
    license = {
      shortName = "3D-Slicer";
      fullName = "3D Slicer Contribution and Software License Agreement";
      url = "https://www.slicer.org/wiki/Documentation/Nightly/License";
      free = true;
    };
    platforms = [ "x86_64-linux" ];
    mainProgram = "3d-slicer";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
