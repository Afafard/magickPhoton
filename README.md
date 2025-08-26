# magickPhoton (mP)

Advanced video/image processing toolbox for macOS

## Features
- Cross-platform CLI and native GUI
- Hardware-accelerated video processing
- AI super-resolution via HuggingFace
- Plugin architecture for extensibility

## Installation
```bash
# Homebrew
brew install magickphoton

# Manual
git clone https://github.com/magickphoton/mp.git
pip install -r requirements.txt
xcodebuild -scheme magickPhoton build
# magickPhoton


Usage Examples

# Convert HEIC to PNG
mP image photo.heic -o converted.png

# Clip video (5s-15s)
mP video input.mov -t 00:00:05-00:00:15 -o clip.mp4

# Super-resolution
mP image lowres.jpg --sr_model=esrgan -o highres.png

GUI Workflow

    Right-click file → "Open With magickPhoton"
    Select crop area visually
    Adjust processing parameters
    Preview results in split-view
    Export final result

Plugins

Create Python files in ~/.config/magickphoton/plugins:

from mp.plugin_base import MPPlugin

class MyPlugin(MPPlugin):
    def register_cli(self, parser):
        parser.add_argument('--custom_effect', help="My custom effect")

License

MIT License - See LICENSE
