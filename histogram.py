from .plugin_base import MPPlugin
import matplotlib.pyplot as plt
import numpy as np

class HistogramPlugin(MPPlugin):
    def register_cli(self, parser):
        parser.add_argument('--histogram', action='store_true', help='Generate image histogram')
        
    def register_gui(self, gui_hooks):
        gui_hooks['Image Ops'].append(
            Toggle("Show Histogram", binding: $showHistogram)
        )
        
    def process(self, args, image=None, video=None):
        if args.histogram and image:
            plt.hist(np.array(image).ravel(), bins=256)
            plt.savefig(args.output)
            return None  # Override output
        return image

