class MPPlugin:
    def register_cli(self, parser):
        """Add CLI arguments"""
        pass
        
    def register_gui(self, gui_hooks):
        """Register GUI elements"""
        pass
        
    def process(self, args, image=None, video=None):
        """Process media"""
        return image or video

