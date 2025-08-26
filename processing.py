"""
Core media processing functions
"""
import subprocess
from PIL import Image, ImageOps
import cv2
import numpy as np
import torch
from transformers import pipeline

def process_media(args):
    if args.command == 'image':
        img = Image.open(args.input)
        
        # Apply operations
        if args.crop:
            x, y, w, h = args.crop
            img = img.crop((x, y, x+w, y+h))
        if args.edge_detect:
            img = cv2.Canny(np.array(img), 100, 200)
            img = Image.fromarray(img)
        if args.sr_model:
            sr_pipe = pipeline('image-super-resolution', model=args.sr_model)
            img = sr_pipe(img)
        img.save(args.output)
        
    elif args.command == 'video':
        cmd = ['ffmpeg', '-i', args.input]
        
        # Build FFmpeg command
        if args.time_crop:
            start, end = args.time_crop.split('-')
            cmd.extend(['-ss', start, '-to', end])
        if args.remove_audio:
            cmd.extend(['-an'])
        if args.interp_fps:
            cmd.extend(['-filter:v', f'minterpolate=fps={args.interp_fps}'])
            
        cmd.append(args.output)
        subprocess.run(cmd, check=True)

