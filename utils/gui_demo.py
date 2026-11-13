"""Local Qt5 demo helper. Run with WSL Ubuntu's python3; never opens hardware ports."""
import argparse
import os
from pathlib import Path
import subprocess
import sys

BASE = Path(__file__).resolve().parents[1]
SOFTWARE = BASE / "software"
GUI = SOFTWARE / "gui"
COMMON = SOFTWARE / "common"
VENV = Path.home() / ".cache" / "respira-gui-venv"
BUILD = GUI / "build"
ENV = dict(os.environ, PATH=f"{VENV / 'bin'}:{os.environ.get('PATH', '')}",
           QT_QPA_PLATFORM="xcb",
           CONAN_HOME=str(Path.home() / ".cache" / "respira-gui-conan"))


def run(*args, cwd=GUI):
    print("+", *map(str, args), flush=True)
    subprocess.run(list(map(str, args)), cwd=cwd, env=ENV, check=True)


def setup():
    run(sys.executable, "-m", "venv", VENV)
    run(VENV / "bin/python", "-m", "pip", "install", "--disable-pip-version-check",
        "--index-url", "https://pypi.org/simple",
        "conan==2.34.0", "platformio==6.1.16", "nanopb==0.4.9.1", "protobuf")
    run("conan", "profile", "detect", "--force")
    run("pio", "pkg", "install", "-e", "native", "--library",
        "nanopb/Nanopb@0.4.93", "--no-save", cwd=COMMON)
    protocols = COMMON / "generated_libs" / "protocols"
    run("protoc", f"--plugin=protoc-gen-nanopb={VENV / 'bin/protoc-gen-nanopb'}",
        f"-I{protocols}", f"--nanopb_out={protocols}", "network_protocol.proto")


def build():
    run("cmake", "-S", GUI, "-B", BUILD, "-G", "Ninja",
        "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5")
    run("cmake", "--build", BUILD, "--target", "ventilator_gui_app",
        "--parallel", "4")


def screenshot(name):
    from PyQt5.QtGui import QGuiApplication
    app = QGuiApplication([])
    result = subprocess.run(
        ["xdotool", "search", "--onlyvisible", "--name", "^Ventilator$"],
        capture_output=True, text=True, check=True, env=ENV)
    window = int(result.stdout.splitlines()[-1])
    image = app.primaryScreen().grabWindow(window)
    if image.isNull():
        raise RuntimeError("Application window capture was empty")
    output = BASE / "assets" / f"{name}.png"
    if not image.save(str(output)):
        raise RuntimeError(f"Could not save {output}")
    print(f"Saved {output} ({image.width()}x{image.height()})", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["setup", "build", "run", "capture", "test"])
    parser.add_argument("--name", default="current-ui")
    args = parser.parse_args()
    if args.action == "setup":
        setup()
    elif args.action == "build":
        build()
    elif args.action == "run":
        run(BUILD / "bin" / "ventilator_gui_app")
    elif args.action == "test":
        run("cmake", "--build", BUILD, "--target", "gui_backend_tests", "--parallel", "4")
        run(BUILD / "bin" / "gui_backend_tests")
    else:
        os.environ["QT_QPA_PLATFORM"] = "xcb"
        screenshot(args.name)


if __name__ == "__main__":
    main()
