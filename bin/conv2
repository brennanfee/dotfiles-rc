#!/usr/bin/env -S uv run --script
# vi: ft=python
#
# /// script
# requires-python = ">=3.14"
# dependencies = [
#   "click",
#   "rich",
# ]
# [tool.uv]
# exclude-newer = "2026-02-24T00:00:00Z"
# ///

import click
from conv_commands import *

@click.group(help="CLI tool to manipulate and manage media files.")
@click.version_option("0.0.1", prog_name="Conv")
def cli() -> None:
    pass

for command in conv_commands.__all__:
    cli.add_command(command)
# cli.add_command(check_streams.check_streams)
# cli.add_command(check_no_audio.check_no_audio)

if __name__ == "__main__":
    cli()
