import argparse
from .processing import process_media

def main():
    parser = argparse.ArgumentParser(prog='mP', description='magickPhoton: Video and Image Toolbox')
    subparsers = parser.add_subparsers(dest='command', required=True)

    # Shared arguments
    base_parser = argparse.ArgumentParser(add_help=False)
    base_parser.add_argument('input', help='Input file path')
    base_parser.add_argument('-o', '--output', required=True, help='Output path')

    # Image operations
    img_parser = subparsers.add_parser('image', parents=[base_parser])
    img_parser.add_argument('--crop', nargs=4, type=int, metavar=('x', 'y', 'w', 'h'), 
                            help='Crop coordinates: x y width height')
    img_parser.add_argument('--edge_detect', action='store_true', 
                            help='Apply edge detection (Canny algorithm)')
    img_parser.add_argument('--flip', choices=['h', 'v'], 
                            help='Flip image horizontally (h) or vertically (v)')
    img_parser.add_argument('--rotate', type=float, 
                            help='Rotate image by specified degrees')
    img_parser.add_argument('--sr_model', 
                            help='HuggingFace model URL or identifier for super-resolution')
    img_parser.add_argument('--line_profile', action='store_true', 
                            help='Extract line profile from image')
    img_parser.add_argument('--fourier', action='store_true', 
                            help='Apply Fourier transform')
    img_parser.add_argument('--mosaic', nargs='+', 
                            help='Image paths for mosaicing')

    # Video operations
    vid_parser = subparsers.add_parser('video', parents=[base_parser])
    vid_parser.add_argument('-t', '--time_crop', 
                            help='Start-end in HH:MM:SS format (e.g., 00:05:00-01:08:00)')
    vid_parser.add_argument('--remove_audio', action='store_true', 
                            help='Remove audio track from video')
    vid_parser.add_argument('--add_audio', 
                            help='External audio file to add to video')
    vid_parser.add_argument('--realign_audio', choices=['best_guess', 'manual'], 
                            help='Align audio with video')
    vid_parser.add_argument('--sr_model', 
                            help='HuggingFace model URL or identifier for super-resolution')
    vid_parser.add_argument('--interp_fps', type=int, 
                            help='Target FPS for frame interpolation')
    vid_parser.add_argument('--compress', choices=['low', 'medium', 'high'], 
                            help='Compression quality preset')
    
    # Plugin support
    vid_parser.add_argument('--plugin_args', nargs='*', 
                            help='Plugin-specific arguments')
    img_parser.add_argument('--plugin_args', nargs='*', 
                            help='Plugin-specific arguments')

    args = parser.parse_args()
    process_media(args)

