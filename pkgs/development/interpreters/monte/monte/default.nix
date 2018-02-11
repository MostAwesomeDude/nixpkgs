{ stdenv, pkgs, lib, callPackage, coreutils, rlwrap }:
let
  typhonVm = callPackage ../typhon/default.nix {};
  mast = callPackage ../mast/default.nix { typhon = typhonVm; };
  loader = "${mast}/loader";
  mt-script = pkgs.writeScript "monte" ''
    #!${stdenv.shell}
    OPERATION=$1
    usage() {
        ${coreutils}/bin/cat <<EOF

    Usage: monte <command>
    Command list:
      repl                      Starts interactive prompt in current package.
      lint <filename>           Reads source file, reports syntax errors.
      bake <filename>           Compiles Monte source code into MAST.
      eval <filename>           Execute the code in a single source file.
      dump-mast <filename.mast> Print the Kernel-Monte from a MAST file.
      format <filename>         Print a canonically-formatted version of source file.

    EOF
        exit $1
    }
    RLWRAP=${rlwrap}/bin/rlwrap
    TYPHON=${typhonVm}/bin/mt-typhon
    LOADER=${loader}
    case $OPERATION in
        repl)
            $RLWRAP $TYPHON -l ${mast}/mast -l ${mast} $LOADER run tools/repl
            ;;
        lint)
            shift
            $TYPHON -l ${mast}/mast -l ${mast} $LOADER \
                       run montec -lint -terse "$@"
            ;;
        bake)
            SOURCE=$2
            if [[ -z $SOURCE ]]; then
                usage 1
            else
                $TYPHON -l ${mast}/mast -l ${mast} $LOADER \
                           run montec -mix "$SOURCE" "''${SOURCE%.mt}.mast"
            fi
            ;;
        eval)
            SOURCE=$2
            if [[ -z $SOURCE ]]; then
                usage 1
            else
                if [[ "$SOURCE" == *.mt ]]; then
                   MASTSOURCE=''${SOURCE%.mt}.mast
                   $TYPHON -l ${mast}/mast -l ${mast} \
                       $LOADER run montec -mix "$SOURCE" "$MASTSOURCE"
                SOURCE=$MASTSOURCE
                fi
                if [[ "$SOURCE" == *.mast ]]; then
                    $TYPHON -l ${mast}/mast -l ${mast} -l $PWD \
                        $LOADER run ''${SOURCE%.mast} "$@"
                fi
            fi
            ;;
        dump-mast)
            SOURCE=$2
            if [[ -z $SOURCE ]]; then
                usage 1
            else
                $TYPHON -l ${mast}/mast -l ${mast} \
                  $LOADER run tools/dump "$SOURCE"
            fi
            ;;
        format)
            SOURCE=$2
            if [[ -z $SOURCE ]]; then
                usage 1
            else
                $TYPHON -l ${mast}/mast -l ${mast} \
                    $LOADER run format "$SOURCE"
            fi
            ;;
        -h|--help)
            usage 0
            ;;
        *)
            usage 1
            ;;
    esac
    '';
in
  stdenv.mkDerivation {
    name = "monte-mini";
    version = "18.0.0";

    src = typhonVm.src;

    buildInputs = [ typhonVm mast rlwrap ];

    dontBuild = true;

    installPhase = ''
      set -e

      mkdir -p $out/bin/
      substituteAll ${mt-script} $out/bin/monte
      chmod +x $out/bin/monte
    '';
  }
