import subprocess
import os
import cv2
import numpy as np
from PIL import Image
from .ai_processing import run_super_resolution
from .audio_align import align_audio

def process_image(args):
    try:
        img = Image.open(args.input)
        
        # Apply operations
        if args.crop:
            x, y, w, h = args.crop
            img = img.crop((x, y, x+w, y+h))
        if args.flip:
            if args.flip == 'h':
                img = img.transpose(Image.FLIP_LEFT_RIGHT)
            elif args.flip == 'v':
                img = img.transpose(Image.FLIP_TOP_BOTTOM)
        if args.rotate:
            img = img.rotate(args.rotate, expand=True)
        if args.edge_detect:
            # Convert to grayscale for edge detection
            gray = np.array(img.convert('L'))
            edges = cv2.Canny(gray, 100, 200)
            img = Image.fromarray(edges)
        if args.sr_model:
            img = run_super_resolution(img, args.sr_model)
        
        img.save(args.output)
        print(f"✅ Image processed successfully: {args.output}")
    except Exception as e:
        print(f"❌ Error processing image: {e}")
        raise

def process_video(args):
    try:
        ffmpeg_cmd = ['ffmpeg', '-i', args.input]
        
        # Time cropping
        if args.time_crop:
            start, end = args.time_crop.split('-')
            ffmpeg_cmd.extend(['-ss', start, '-to', end])
        
        # Audio handling
        if args.remove_audio:
            ffmpeg_cmd.extend(['-an'])
        elif args.add_audio:
            ffmpeg_cmd.extend(['-i', args.add_audio, '-c:a', 'aac'])
        
        # Audio alignment
        if args.realign_audio:
            ffmpeg_cmd = align_audio(ffmpeg_cmd, method=args.realign_audio)
        
        # Frame interpolation
        if args.interp_fps:
            ffmpeg_cmd.extend(['-filter:v', f'minterpolate=fps={args.interp_fps}'])
        
        # Compression
        if args.compress:
            quality_map = {'high': '18', 'medium': '23', 'low': '28'}
            quality = quality_map[args.compress]
            ffmpeg_cmd.extend(['-c:v', 'hevc_videotoolbox', '-q:v', quality])
        
        ffmpeg_cmd.append(args.output)
        
        # Run FFmpeg command
        print("🚀 Processing video with command:")
        print(" ".join(ffmpeg_cmd))
        result = subprocess.run(ffmpeg_cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"❌ FFmpeg error: {result.stderr}")
            raise subprocess.CalledProcessError(result.returncode, ffmpeg_cmd, result.stdout, result.stderr)
        
        print(f"✅ Video processed successfully: {args.output}")
    except Exception as e:
        print(f"❌ Error processing video: {e}")
        raise

def process_media(args):
    if args.command == 'image':
        process_image(args)
    elif args.command == 'video':
        process_video(args)
    else:
        raise ValueError(f"Unknown command: {args.command}")

