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
import subprocess
from rich.console import Console
import click
from typing import override
import shutil
import send2trash

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
        "sm": "stripMeta",
        "convmkv": "convertmkvs",
        "convmkvs": "convertmkvs",
        "subs": "extractSubtitles",
        "concat": "concatenateFiles",
        "trimstart": "trimFromStart",
        "trimend": "trimFromEnd",
        "trim": "trimFile",
        "noaudio": "showFilesWithNoAudio",
    }

    @override
    def get_command(self, ctx: click.Context, cmd_name: str):
        # Step one: built-in commands as normal
        rv = super().get_command(ctx, cmd_name.lower())
        if rv is not None:
            return rv

        # Step two: Manually map my specific choices
        try:
            actual_cmd = self.ALIASES[cmd_name.lower()]
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

    @override
    def resolve_command(self, ctx: click.Context, args):
        # always return the command's name, not the alias
        _, cmd, args = super().resolve_command(ctx, args)
        return cmd.name, cmd, args


def safeRemoveFile(filePath: str):
    if os.path.exists(filePath):
        try:
            send2trash.send2trash(filePath)
        except send2trash.TrashPermissionError:
            os.remove(filePath)


@click.command(cls=AliasedGroup)
@click.pass_context
def cli(ctx: click.Context):
    the_console = Console(highlight=False)
    ctx.obj = the_console


@cli.command()
@click.argument(
    "path",
    default=".",
    type=click.Path(exists=True, file_okay=False, resolve_path=True),
)
@click.option("-R", "--recursive", is_flag=True, default=False, show_default=True)
@click.option("-F", "--force", is_flag=True, default=False, show_default=True)
@pass_console
def stripMeta(console, path: str, recursive: bool, force: bool):
    search = "*.mp4"
    if recursive:
        search = f"**/{search}"

    for mp4File in glob.iglob(search, root_dir=path, recursive=recursive):
        console.print(f"[blue]Checking file:[/blue] {mp4File}")
        fullPath = os.path.join(path, mp4File)
        hasMeta = subprocess.run(
            f'mediainfo "{fullPath}" | grep -i "Movie name\\|Title"',
            shell=True,
            capture_output=True,
            text=True,
        )
        if hasMeta.stdout != "" or force:
            console.print(f"[yellow]Stripping metadata for:[/yellow] {mp4File}")
            tmpFile = os.path.join(path, f"fixed-{mp4File}")
            try:
                cmd = f'ffmpeg -i "{fullPath}" -map_metadata -1 -codec copy -movflags +faststart "{tmpFile}"'
                _ = subprocess.check_output(cmd, shell=True, text=True)
                shutil.move(tmpFile, fullPath)
                console.print(f"[green]Successfully converted:[/green] {mp4File}")
            except subprocess.CalledProcessError as e:
                safeRemoveFile(tmpFile)
                console.print(f"[red]Error converting '{mp4File}' : {e}")


@cli.command()
@click.argument(
    "path",
    default=".",
    type=click.Path(exists=True, file_okay=False, resolve_path=True),
)
@click.option("-R", "--recursive", is_flag=True, default=False, show_default=True)
@pass_console
def convertMkvs(console, path: str, recursive: bool):
    search = "*.mkv"
    if recursive:
        search = f"**/{search}"

    for mkvFile in glob.iglob(search, root_dir=path, recursive=recursive):
        console.print(f"[blue]Converting file:[/blue] {mkvFile}")
        fullPath = os.path.join(path, mkvFile)
        destFile = ""
        try:
            splitFile, _ = os.path.splitext(fullPath)
            destFile = f"{splitFile}.mp4"

            cmd = f'ffmpeg -i "{fullPath}" -map_metadata -1 -codec copy -movfalgs +faststart "{destFile}"'
            _ = subprocess.check_output(cmd, shell=True, text=True)
            safeRemoveFile(fullPath)
            console.print(f"[green]Successfully converted:[/green] {mkvFile}")
        except subprocess.CalledProcessError as e:
            safeRemoveFile(destFile)
            console.print(f"[red]Error converting '{mkvFile}' : {e}")


@cli.command()
@click.argument("file", type=click.Path(exists=True, dir_okay=False, resolve_path=True))
@click.argument("index", type=int, default=0)
@pass_console
def extractSubtitles(console, file: str, index: int):
    splitFile, _ = os.path.splitext(file)
    outputFile = f"{splitFile}.srt"
    try:
        cmd = f'ffmpeg -i "{file}" -map 0:s:{index} "{outputFile}"'
        _ = subprocess.check_output(cmd, shell=True, text=True)
        console.print(f"[green]Successfully extracted:[/green] {outputFile}")
    except subprocess.CalledProcessError as e:
        console.print(f"[red]Error extracting subtitles for file '{file}' : {e}")


@cli.command()
@click.argument(
    "outputFile", type=click.Path(exists=False, dir_okay=False, resolve_path=True)
)
@click.argument(
    "files", nargs=-1, type=click.Path(exists=True, dir_okay=False, resolve_path=True)
)
@pass_console
def concatenateFiles(console, outputFile: str, files: list[str]):
    path = os.path.dirname(outputFile)
    tmpFile = os.path.join(path, "combine.txt")
    with open(tmpFile, "w") as tmpFileHandle:
        for file in files:
            _ = tmpFileHandle.write(file)

    try:
        cmd = f'ffmpeg -f concat -safe 0 -i "{tmpFile}" -codec copy -movflags +faststart "{outputFile}"'
        _ = subprocess.check_output(cmd, shell=True, text=True)
        safeRemoveFile(tmpFile)
        console.print(f"[green]Successfully combined:[/green] {outputFile}")
    except subprocess.CalledProcessError as e:
        safeRemoveFile(tmpFile)
        console.print(f"[red]Error combining files: {e}")


@cli.command()
@click.argument("file", type=click.Path(exists=True, dir_okay=False, resolve_path=True))
@click.argument(
    "outputFile", type=click.Path(exists=False, dir_okay=False, resolve_path=True)
)
@click.argument("trimStart")
@pass_console
def trimFromStart(console, file: str, outputFile: str, trimStart: str):
    try:
        cmd = f'ffmpeg -i "{file}" -codec copy -ss {trimStart} -movflags +faststart "{outputFile}"'
        _ = subprocess.check_output(cmd, shell=True, text=True)
        console.print(f"[green]Successfully trimmed:[/green] {outputFile}")
    except subprocess.CalledProcessError as e:
        safeRemoveFile(outputFile)
        console.print(f"[red]Error trimming file '{file}': {e}")


@cli.command()
@click.argument("file", type=click.Path(exists=True, dir_okay=False, resolve_path=True))
@click.argument(
    "outputFile", type=click.Path(exists=False, dir_okay=False, resolve_path=True)
)
@click.argument("trimEnd")
@pass_console
def trimFromEnd(console, file: str, outputFile: str, trimEnd: str):
    try:
        if trimEnd.startswith("-") or trimEnd == "0":
            cmd = f'ffmpeg -i "{file}" -codec copy -sseof {trimEnd} -movflags +faststart "{outputFile}"'
        else:
            cmd = f'ffmpeg -i "{file}" -codec copy -t {trimEnd} -movflags +faststart "{outputFile}"'

        _ = subprocess.check_output(cmd, shell=True, text=True)
        console.print(f"[green]Successfully trimmed:[/green] {outputFile}")
    except subprocess.CalledProcessError as e:
        safeRemoveFile(outputFile)
        console.print(f"[red]Error trimming file '{file}': {e}")


@cli.command()
@click.argument("file", type=click.Path(exists=True, dir_okay=False, resolve_path=True))
@click.argument(
    "outputFile", type=click.Path(exists=False, dir_okay=False, resolve_path=True)
)
@click.argument("trimStart")
@click.argument("trimEnd")
@pass_console
def trimFile(console, file: str, outputFile: str, trimStart: str, trimEnd: str):
    try:
        if trimEnd.startswith("-") or trimEnd == "0":
            cmd = f'ffmpeg -i "{file}" -codec copy -ss {trimStart} -sseof {trimEnd} -movflags +faststart "{outputFile}"'
        else:
            cmd = f'ffmpeg -i "{file}" -codec copy -ss {trimStart} -t {trimEnd} -movflags +faststart "{outputFile}"'

        _ = subprocess.check_output(cmd, shell=True, text=True)
        console.print(f"[green]Successfully trimmed:[/green] {outputFile}")
    except subprocess.CalledProcessError as e:
        safeRemoveFile(outputFile)
        console.print(f"[red]Error trimming file '{file}': {e}")


@cli.command()
@click.argument(
    "path",
    default=".",
    type=click.Path(exists=True, file_okay=False, resolve_path=True),
)
@click.option("-R", "--recursive", is_flag=True, default=False, show_default=True)
@click.option("-q", "--quiet", is_flag=True, default=False, show_default=True)
@pass_console
def showFilesWithNoAudio(console, path: str, recursive: bool, quiet: bool):
    search = "*.mp4"
    if recursive:
        search = f"**/{search}"

    for mp4File in glob.iglob(search, root_dir=path, recursive=recursive):
        fullPath = os.path.join(path, mp4File)
        if not quiet:
            console.print(f"[blue]Checking file:[/blue] {mp4File}")
        hasAudio = subprocess.run(
            f'mediainfo "{fullPath}" | grep -i "audio"',
            shell=True,
            capture_output=True,
            text=True,
        )
        if hasAudio.stdout == "":
            if quiet:
                console.print(f"{fullPath}")
            else:
                console.print(f"[yellow]{fullPath} has no audio[/yellow]")


if __name__ == "__main__":
    cli()
