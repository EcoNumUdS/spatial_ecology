"""Inline the figures and stats into a single self-contained HTML page.

    python html/build.py

Reads  html/tutorial.html   (template, with {{TOKEN}} placeholders)
       output/figures/*     (produced by Rscript R/figures.R)
Writes output/tutorial.html (one file, no external assets)
"""
import base64
import pathlib
import sys

root = pathlib.Path(__file__).resolve().parent.parent
figures = root / "output" / "figures"
template = root / "html" / "tutorial.html"
out = root / "output" / "tutorial.html"


def data_uri(name):
    path = figures / name
    if not path.exists():
        sys.exit(f"missing {path}\nRun: Rscript R/figures.R")
    encoded = base64.b64encode(path.read_bytes()).decode("ascii")
    return f"data:image/png;base64,{encoded}"


def r_source(name, first, last):
    """Lines first..last of an R file, as escaped HTML."""
    lines = (root / "R" / name).read_text(encoding="utf-8").splitlines()
    text = "\n".join(lines[first - 1:last])
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


stats = (figures / "stats.json").read_text(encoding="utf-8").strip()

tokens = {
    "{{STATS_JSON}}": stats,
    "{{IMG_MAP_LARGE}}": data_uri("map_large.png"),
    "{{IMG_FRONT_1}}": data_uri("front_1.png"),
    "{{IMG_FRONT_2}}": data_uri("front_2.png"),
    "{{IMG_FRONT_3}}": data_uri("front_3.png"),
    "{{IMG_FRONT_4}}": data_uri("front_4.png"),
    # Code shown on the page is pulled straight from the R sources, so the
    # snippets cannot drift away from the code that actually runs.
    "{{CODE_STATES}}": r_source("forest_fire.R", 19, 22),
    "{{CODE_NEIGHBOUR}}": r_source("forest_fire.R", 45, 65),
    "{{CODE_STEP}}": r_source("forest_fire.R", 74, 99),
    "{{CODE_SIMULATE}}": r_source("forest_fire.R", 110, 128),
}

html = template.read_text(encoding="utf-8")
for token, value in tokens.items():
    if token not in html:
        sys.exit(f"token {token} not found in template")
    html = html.replace(token, value)

out.write_text(html, encoding="utf-8")
print(f"wrote {out}  ({out.stat().st_size / 1024:.0f} KB)")
