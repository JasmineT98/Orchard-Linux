import json
import os
import subprocess
from pathlib import Path

import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, Gdk, GLib

ORANGE = "#ff7a00"
SETTINGS_FILE = Path.home() / ".config" / "orchard" / "settings.json"

DEFAULT_SETTINGS = {
    "appearance": "dark",
    "dock_visible": True,
    "dock_size": 62,
    "window_gap": 8,
    "wallpaper": "/usr/share/backgrounds/orchard/orchard.png",
    "lock_wallpaper": "/usr/share/backgrounds/orchard/orchard-lock.png",
}

DARK_CSS = """
window {
  background-color: #202024;
  color: #f5f5f7;
}
headerbar, .titlebar {
  background-color: #29292e;
  color: #f5f5f7;
}
entry, textview, list, listbox, scrolledwindow, viewport {
  background-color: #25252a;
  color: #f5f5f7;
}
button {
  border-radius: 10px;
  padding: 7px 12px;
}
button.suggested-action {
  background: #ff7a00;
  color: white;
}
.orchard-card {
  background: #2c2c31;
  border: 1px solid rgba(255,255,255,0.10);
  border-radius: 14px;
  padding: 12px;
}
.orchard-title {
  font-size: 24px;
  font-weight: 700;
}
.orchard-subtitle {
  color: #aaaab2;
}
"""

LIGHT_CSS = """
window {
  background-color: #f4f4f6;
  color: #202024;
}
headerbar, .titlebar {
  background-color: #ececef;
  color: #202024;
}
entry, textview, list, listbox, scrolledwindow, viewport {
  background-color: #ffffff;
  color: #202024;
}
button {
  border-radius: 10px;
  padding: 7px 12px;
}
button.suggested-action {
  background: #ff7a00;
  color: white;
}
.orchard-card {
  background: #ffffff;
  border: 1px solid rgba(0,0,0,0.10);
  border-radius: 14px;
  padding: 12px;
}
.orchard-title {
  font-size: 24px;
  font-weight: 700;
}
.orchard-subtitle {
  color: #6f6f75;
}
"""

def load_settings():
    data = dict(DEFAULT_SETTINGS)
    try:
        data.update(json.loads(SETTINGS_FILE.read_text()))
    except Exception:
        pass
    return data

def save_settings(data):
    SETTINGS_FILE.parent.mkdir(parents=True, exist_ok=True)
    SETTINGS_FILE.write_text(json.dumps(data, indent=2) + "\\n")

def set_setting(key, value):
    data = load_settings()
    data[key] = value
    save_settings(data)

def run(cmd, **kwargs):
    return subprocess.run(cmd, text=True, capture_output=True, **kwargs)

def spawn(cmd):
    try:
        return subprocess.Popen(cmd, start_new_session=True)
    except Exception:
        return None

def install_css(extra=""):
    settings = load_settings()
    css = DARK_CSS if settings.get("appearance") == "dark" else LIGHT_CSS
    provider = Gtk.CssProvider()
    raw = (css + "\\n" + extra)
    try:
        provider.load_from_data(raw.encode())
    except TypeError:
        provider.load_from_data(raw)
    display = Gdk.Display.get_default()
    if display:
        Gtk.StyleContext.add_provider_for_display(
            display, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

def titled_label(title, subtitle=None):
    box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=3)
    title_label = Gtk.Label(label=title, xalign=0)
    title_label.add_css_class("orchard-title")
    box.append(title_label)
    if subtitle:
        sub = Gtk.Label(label=subtitle, xalign=0)
        sub.add_css_class("orchard-subtitle")
        sub.set_wrap(True)
        box.append(sub)
    return box

def card():
    b = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
    b.add_css_class("orchard-card")
    return b

def icon_button(icon_name, size=20):
    button = Gtk.Button()
    image = Gtk.Image.new_from_icon_name(icon_name)
    image.set_pixel_size(size)
    button.set_child(image)
    return button

def file_picker(title, save=False):
    cmd = ["/usr/bin/zenity", "--file-selection", f"--title={title}"]
    if save:
        cmd += ["--save", "--confirm-overwrite"]
    cp = run(cmd)
    if cp.returncode == 0:
        return cp.stdout.strip()
    return None

def notify(summary, body=""):
    cmd = ["/usr/bin/notify-send", summary]
    if body:
        cmd.append(body)
    try:
        subprocess.Popen(cmd)
    except Exception:
        pass

def reboot_shell():
    spawn(["/usr/bin/systemctl", "--user", "restart", "orchard-shell.service"])

def restart_wallpaper():
    spawn(["/usr/bin/systemctl", "--user", "restart", "orchard-wallpaper.service"])

def human_bytes(value):
    value = float(value)
    for unit in ("B", "KB", "MB", "GB", "TB"):
        if value < 1024:
            return f"{value:.1f} {unit}"
        value /= 1024
    return f"{value:.1f} PB"

def show_message(parent, title, message):
    dialog = Gtk.MessageDialog(
        transient_for=parent,
        modal=True,
        buttons=Gtk.ButtonsType.OK,
        text=title,
        secondary_text=message,
    )
    dialog.connect("response", lambda d, _r: d.close())
    dialog.present()

def escape(text):
    return GLib.markup_escape_text(str(text))
