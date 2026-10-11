import click


@click.command(
    help="Show files with more than 1 video or audio streams, or with no video or audio streams."
)
@click.argument("path",
                type=click.Path(
                    exists=True
                ),
)
def check_streams():
    pass
