"""Generate Android launcher/splash icons and Windows app_icon.ico from assets/logo.png."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
LOGO_PATH = ROOT / "assets" / "logo.png"
RES = ROOT / "android" / "app" / "src" / "main" / "res"
WIN_ICON = ROOT / "windows" / "runner" / "resources" / "app_icon.ico"

BG = (6, 17, 31, 255)  # #06111f


def fit_logo(canvas_size: int, padding_ratio: float = 0.12) -> Image.Image:
    logo = Image.open(LOGO_PATH).convert("RGBA")
    inner = int(canvas_size * (1 - 2 * padding_ratio))
    logo.thumbnail((inner, inner), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (canvas_size, canvas_size), BG)
    x = (canvas_size - logo.width) // 2
    y = (canvas_size - logo.height) // 2
    canvas.paste(logo, (x, y), logo)
    return canvas


def adaptive_foreground(size: int) -> Image.Image:
    logo = Image.open(LOGO_PATH).convert("RGBA")
    inner = int(size * 0.62)
    logo.thumbnail((inner, inner), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    x = (size - logo.width) // 2
    y = (size - logo.height) // 2
    canvas.paste(logo, (x, y), logo)
    return canvas


def splash_port(width: int, height: int) -> Image.Image:
    logo = Image.open(LOGO_PATH).convert("RGBA")
    inner = int(min(width, height) * 0.55)
    logo.thumbnail((inner, inner), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (width, height), BG)
    x = (width - logo.width) // 2
    y = (height - logo.height) // 2
    canvas.paste(logo, (x, y), logo)
    return canvas


def splash_land(width: int, height: int) -> Image.Image:
    return splash_port(width, height)


def save_png(path: Path, image: Image.Image) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, format="PNG", optimize=True)


def write_ico(path: Path, sizes: list[int]) -> None:
    images = [fit_logo(s, padding_ratio=0.08).convert("RGBA") for s in sizes]
    path.parent.mkdir(parents=True, exist_ok=True)
    images[0].save(path, format="ICO", sizes=[(s, s) for s in sizes], append_images=images[1:])


def main() -> None:
    if not LOGO_PATH.exists():
        raise SystemExit(f"Missing logo: {LOGO_PATH}")

    densities = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    fg_densities = {
        "mipmap-mdpi": 108,
        "mipmap-hdpi": 162,
        "mipmap-xhdpi": 216,
        "mipmap-xxhdpi": 324,
        "mipmap-xxxhdpi": 432,
    }
    splash_port_sizes = {
        "drawable-port-mdpi": (320, 480),
        "drawable-port-hdpi": (480, 800),
        "drawable-port-xhdpi": (720, 1280),
        "drawable-port-xxhdpi": (960, 1600),
        "drawable-port-xxxhdpi": (1280, 1920),
    }
    splash_land_sizes = {
        "drawable-land-mdpi": (480, 320),
        "drawable-land-hdpi": (800, 480),
        "drawable-land-xhdpi": (1280, 720),
        "drawable-land-xxhdpi": (1600, 960),
        "drawable-land-xxxhdpi": (1920, 1280),
    }

    for folder, size in densities.items():
        icon = fit_logo(size)
        save_png(RES / folder / "ic_launcher.png", icon)
        save_png(RES / folder / "ic_launcher_round.png", icon)

    for folder, size in fg_densities.items():
        save_png(RES / folder / "ic_launcher_foreground.png", adaptive_foreground(size))

    save_png(RES / "drawable" / "splash.png", splash_port(480, 800))

    for folder, (w, h) in splash_port_sizes.items():
        save_png(RES / folder / "splash.png", splash_port(w, h))

    for folder, (w, h) in splash_land_sizes.items():
        save_png(RES / folder / "splash.png", splash_land(w, h))

    write_ico(WIN_ICON, [16, 32, 48, 64, 128, 256])
    print(f"Generated Android icons + {WIN_ICON}")


if __name__ == "__main__":
    main()
