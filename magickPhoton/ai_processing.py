from transformers import pipeline
from PIL import Image
import requests
from io import BytesIO
import torch

def run_super_resolution(image, model_id):
    """
    Enhance image resolution using HuggingFace model
    """
    try:
        print(f"🔍 Loading super-resolution model: {model_id}")
        
        # Use default model if none specified
        if not model_id:
            model_id = "eugenesiow/sr-div2k"
        
        # Initialize pipeline
        sr_pipe = pipeline('image-to-image', model=model_id, device=0 if torch.cuda.is_available() else -1)
        
        print("⚡ Processing image with AI...")
        result = sr_pipe(image)
        
        if isinstance(result, list) and len(result) > 0:
            return result[0]  # Return first result if multiple
        
        return result
    except Exception as e:
        print(f"❌ AI processing error: {e}")
        raise

