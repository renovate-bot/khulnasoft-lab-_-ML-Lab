import os
from argparse import ArgumentParser
from pathlib import Path

from ml_buildkit import build_utils

HERE = os.path.abspath(os.path.dirname(__file__))
ml_lab_components = [f.name for f in Path('.').iterdir() if f.is_dir() and f.name != "template"]

parser = ArgumentParser()
parser.add_argument(
    f"--docknet-version", help="Version of the docknet library to use."
)
args = build_utils.parse_arguments(argument_parser=parser)

build_utils.log("Building all ML Lab components")
for component in ml_lab_components:
    if (Path(component) / 'build.py').exists():
        build_utils.build(component, args)
