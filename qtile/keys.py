from groups import groups
from libqtile.config import Key
from libqtile.lazy import lazy
from functions import grow_window, toggle_floating, toggle_widgetbox


# 1: alt    4: super
mod = 'mod1'

keys = [
    Key([mod], 'w', lazy.window.kill(), desc='Kill focused window'),

    # Control Window Size
    Key([mod], "m", lazy.window.toggle_minimize(), desc="Toggle minimize"),
    Key([mod, "shift"], "m", lazy.window.toggle_maximize(), desc="Toggle maximize"),

    # Move Windows
    Key([mod, "control"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "control"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "control"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, 'control'], 'f', toggle_floating(), desc='Toggle floating'),

    # Resize Windows
    # Key([mod, "shift"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    # Key([mod, "shift"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    # Key([mod, "shift"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    # Key([mod, "shift"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "shift"], "h", grow_window('h'), desc="Grow window to the left"),
    Key([mod, "shift"], "l", grow_window('l'), desc="Grow window to the right"),
    Key([mod, "shift"], "j", grow_window('j'), desc="Grow window down"),
    Key([mod, "shift"], "k", grow_window('k'), desc="Grow window up"),
    Key([mod, 'shift'], 'n', lazy.layout.normalize(), desc='Reset all window sizes'),

    # Focus Windows
    Key([mod], 'h', lazy.layout.left(), desc='Move focus to left'),
    Key([mod], 'l', lazy.layout.right(), desc='Move focus to right'),
    Key([mod], 'j', lazy.layout.down(), desc='Move focus down'),
    Key([mod], 'k', lazy.layout.up(), desc='Move focus up'),

    # Toggle WidgetBoxes
    Key([mod, 'shift'], '1', toggle_widgetbox(1)),
    Key([mod, 'shift'], '2', toggle_widgetbox(2)),

    # Launch Programs
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Take a screenshot"),
    Key([mod], "Return", lazy.spawn("kitty"), desc="Launch terminal"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Spawn a command using a prompt widget"),
    Key([mod], 'f', lazy.spawn('pcmanfm'), desc='Launch file manager'),

    Key([mod], 'Tab', lazy.next_layout(), desc='Toggle through layouts'),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
]

for group in groups:
    keys.extend(
        [
            Key(
                [mod],
                group.name,
                lazy.group[group.name].toscreen(),
                desc=f"Switch to group {group.name}",
            ),
            Key(
                [mod, "control"],
                group.name,
                lazy.window.togroup(group.name, switch_group=True),
                desc=f"Switch to & move focused window to group {group.name}",
            ),
        ]
    )
