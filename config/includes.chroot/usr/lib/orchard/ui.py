import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, Gdk

CSS = b"""
window {
  background: #f4f4f6;
  color: #1f1f23;
}
headerbar {
  background: #ececef;
}
button {
  border-radius: 9px;
}
.orchard-title {
  font-size: 24px;
  font-weight: 700;
}
.orchard-subtitle {
  color: #6f6f75;
}
"""

def install_css():
    provider = Gtk.CssProvider()
    provider.load_from_data(CSS)
    display = Gdk.Display.get_default()
    Gtk.StyleContext.add_provider_for_display(
        display,
        provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
    )

def titled_label(title, subtitle=None):
    box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
    label = Gtk.Label(label=title, xalign=0)
    label.add_css_class("orchard-title")
    box.append(label)
    if subtitle:
        sub = Gtk.Label(label=subtitle, xalign=0)
        sub.add_css_class("orchard-subtitle")
        sub.set_wrap(True)
        box.append(sub)
    return box
