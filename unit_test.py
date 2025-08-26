```

---

#### 8️⃣ Unit Tests
**test_processing.py**
```python
import pytest
import os
from PIL import Image
from magickphoton.processing import process_media

@pytest.fixture
def test_image(tmp_path):
    img_path = tmp_path / "test.png"
    Image.new('RGB', (100, 100), color='red').save(img_path)
    return img_path

def test_image_crop(test_image, tmp_path):
    output = tmp_path / "cropped.png"
    args = type('', (), {
        'command': 'image',
        'input': str(test_image),
        'output': str(output),
        'crop': [10, 10, 50, 50]
    })
    process_media(args)
    img = Image.open(output)
    assert img.size == (50, 50)

def test_video_clip(tmp_path):
    # Requires test video file
    input_vid = "test.mp4"
    output = tmp_path / "clipped.mp4"
    args = type('', (), {
        'command': 'video',
        'input': input_vid,
        'output': str(output),
        'time_crop': "00:00:01-00:00:02"
    })
    process_media(args)
    assert os.path.exists(output)

