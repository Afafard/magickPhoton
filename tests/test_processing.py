import pytest
import os
from PIL import Image
import tempfile
from magickPhoton.processing import process_image, process_video

@pytest.fixture
def test_image():
    img_path = "test_image.png"
    img = Image.new('RGB', (100, 100), color='red')
    img.save(img_path)
    yield img_path
    if os.path.exists(img_path):
        os.remove(img_path)

def test_image_crop(test_image):
    output = "cropped.png"
    args = type('Args', (), {
        'command': 'image',
        'input': test_image,
        'output': output,
        'crop': [10, 10, 50, 50]
    })
    
    try:
        process_image(args)
        assert os.path.exists(output)
        
        img = Image.open(output)
        assert img.size == (50, 50)
    finally:
        if os.path.exists(output):
            os.remove(output)

def test_image_edge_detection(test_image):
    output = "edges.png"
    args = type('Args', (), {
        'command': 'image',
        'input': test_image,
        'output': output,
        'edge_detect': True
    })
    
    try:
        process_image(args)
        assert os.path.exists(output)
        
        img = Image.open(output)
        assert img.mode == 'L'  # Should be grayscale
    finally:
        if os.path.exists(output):
            os.remove(output)

# Video tests require actual video files
# For CI/CD, we'd use a small test video
@pytest.mark.skipif(not os.path.exists("test_video.mp4"), reason="Test video not found")
def test_video_clipping():
    output = "clipped.mp4"
    args = type('Args', (), {
        'command': 'video',
        'input': "test_video.mp4",
        'output': output,
        'time_crop': "00:00:01-00:00:02"
    })
    
    try:
        process_video(args)
        assert os.path.exists(output)
        # Additional checks could include verifying duration
    finally:
        if os.path.exists(output):
            os.remove(output)

