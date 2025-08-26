"""
magickPhoton CLI Entry Point
"""
import argparse
import sys
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
    img_parser.add_argument('--crop', nargs=4, type=int, metavar=('x', 'y', 'w', 'h'))
    img_parser.add_argument('--edge_detect', action='store_true')
    img_parser.add_argument('--flip', choices=['h', 'v'])
    img_parser.add_argument('--rotate', type=float)
    img_parser.add_argument('--sr_model', help='HF model URL')
    img_parser.add_argument('--line_profile', action='store_true')
    img_parser.add_argument('--fourier', action='store_true')
    img_parser.add_argument('--mosaic', nargs='+', help='Image paths for mosaicing')

    # Video operations
    vid_parser = subparsers.add_parser('video', parents=[base_parser])
    vid_parser.add_argument('-t', '--time_crop', help='Start-end in HH:MM:SS format')
    vid_parser.add_argument('--remove_audio', action='store_true')
    vid_parser.add_argument('--add_audio', help='External audio file')
    vid_parser.add_argument('--realign_audio', choices=['best_guess', 'manual'])
    vid_parser.add_argument('--sr_model', help='HF model URL')
    vid_parser.add_argument('--interp_fps', type=int)
    vid_parser.add_argument('--compress', choices=['low', 'medium', 'high'])

    args = parser.parse_args()
    process_media(args)

if __name__ == '__main__':
    main()

