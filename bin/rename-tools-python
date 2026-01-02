#!/usr/bin/env -S uv run -qs
# vim: set ft=python :
# /// script
# requires-python = ">=3.12"
# dependencies = [
#  "click>=8.1",
#  "rich>=13.6",
#  "send2trash>=1.8.3",
# ]
# [tool.uv]
# native-tls = true
# ///

##########################################
# Utility methods to manipulate various types of media files
#

import os
import glob
from rich.console import Console
import click
import shutil

# TODO: Send errors to stderr
# TODO: Return exit code of 1 on errors
# TODO: Version display
# TODO: Help dipslay

pass_console = click.make_pass_decorator(Console, ensure=True)


class AliasedGroup(click.Group):
    """This subclass of a group supports looking up aliases in a config
    file and with a bit of magic.
    """

    ALIASES = {
        "fp": "fixPeriods",
        "periods": "fixPeriods",
    }

    def get_command(self, ctx, cmd_name):
        # Step one: bulit-in commands as normal
        rv = super().get_command(ctx, cmd_name.lower())
        if rv is not None:
            return rv

        # Step two: Manually map my specific choices
        try:
            actual_cmd = self.ALIASES[cmd_name]
            return super().get_command(ctx, actual_cmd.lower())
        except KeyError:
            pass

        # Step three: Allow automatic abbreviation of the command.
        matches = [
            x for x in self.list_commands(ctx) if x.lower().startswith(cmd_name.lower())
        ]
        if not matches:
            return None
        elif len(matches) == 1:
            return super().get_command(ctx, matches[0])
        ctx.fail(f"Too many matches: {', '.join(sorted(matches))}")

    def resolve_command(self, ctx, args):
        # always return the command's name, not the alias
        _, cmd, args = super().resolve_command(ctx, args)
        return cmd.name, cmd, args


@click.command(cls=AliasedGroup)
@click.pass_context
def cli(ctx):
    the_console = Console(highlight=False)
    ctx.obj = the_console


@cli.command()
@click.argument(
    "path",
    default=".",
    type=click.Path(exists=True, file_okay=False, resolve_path=True),
)
@click.option("-R", "--recursive", is_flag=True, default=False, show_default=True)
@pass_console
def fixPeriods(console, path, recursive):
    search = "*"
    if recursive:
        search = f"**/{search}"

    for file in glob.iglob(search, root_dir=path, recursive=recursive):
        fullFile = os.path.join(path, file)
        if os.path.isdir(fullFile):
            continue

        # We only want to replace periods in the filename part (not the path)
        fileBase = os.path.basename(fullFile)
        filePath = os.path.dirname(fullFile)
        filePart, extension = os.path.splitext(fileBase)
        filePart = filePart.replace(".", " ")
        newFile = os.path.join(filePath, f"{filePart}{extension}")

        if fullFile == newFile:
            continue

        if os.path.exists(newFile):
            console.print(
                f"[yellow]Cannot rename '{fullFile}' because '{newFile}' already exists.[/yellow]"
            )
            continue

        shutil.move(fullFile, newFile)
        console.print(f"[blue]Renamed '{fullFile}' to '{newFile}'")


@cli.command
@click.argument(
    "path",
    default=".",
    type=click.Path(exists=True, file_okay=False, resolve_path=True),
)
@click.argument("show_name", default="")
@click.option("-t", "--test", is_flag=True, default=False, show_default=True)
@pass_console
def renameJustSeasonAndEpisode(console, path: str, show_name: str, test: bool):
    fileSearch = os.path.join(path, "*.mp4")

    pattern = r"s/(.*)[\. ][Ss](\d\d)[Ee](\d\d).*$/$1 s$2e$3\.mp4/"
    if show_name:
        pattern = rf"s/.*[Ss](\d\d)[Ee](\d\d).*$/{show_name} s$1e$2\.mp4/"

    cmd = f"rename -f '{pattern}' {fileSearch}"
    if test:
        cmd = f"{cmd} -n"


if __name__ == "__main__":
    cli()
