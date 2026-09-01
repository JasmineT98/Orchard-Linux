import os
from pathlib import Path
import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, Gdk

BASE_CSS = "/usr/share/orchard-ui/orchard.css"
DARK_CSS = "/usr/share/orchard-ui/orchard-dark.css"

def is_dark():
    return Path.home().joinpath('.config/orchard/dark').exists()

def apply_css():
    display = Gdk.Display.get_default()
    if not display: return
    provider = Gtk.CssProvider()
    provider.load_from_path(DARK_CSS if is_dark() else BASE_CSS)
    Gtk.StyleContext.add_provider_for_display(display, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

def window(app, title, width=900, height=620):
    w = Gtk.ApplicationWindow(application=app, title=title)
    w.set_default_size(width, height)
    w.add_css_class('orchard-window')
    header = Gtk.HeaderBar()
    header.set_show_title_buttons(True)
    header.set_title_widget(Gtk.Label(label=title))
    header.add_css_class('orchard-header')
    w.set_titlebar(header)
    return w

def button(label, suggested=False):
    b=Gtk.Button(label=label)
    b.add_css_class('orchard-button')
    if suggested: b.add_css_class('suggested-action')
    return b

def page_title(title, subtitle=None):
    box=Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
    t=Gtk.Label(label=title, xalign=0); t.add_css_class('page-title'); box.append(t)
    if subtitle:
        s=Gtk.Label(label=subtitle, xalign=0); s.set_wrap(True); s.add_css_class('muted'); box.append(s)
    return box
