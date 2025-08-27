from setuptools import setup, find_packages

setup(
    name='magickphoton',
    version='0.1.0',
    packages=find_packages(),
    entry_points={
        'console_scripts': [
            'mP = mP:main',
        ],
    },
    install_requires=[
        'Pillow>=10.0',
        'opencv-python-headless',
        'pyobjc-framework-AVFoundation',
        'imageio-ffmpeg',
        'PyPDF2>=3.0.0',
        'ffmpeg-python==0.2.0',
        'av==10.0.0',
        'torch>=2.0',
        'transformers[torch]>=4.30',
        'diffusers>=0.20.0',
        'accelerate>=0.23.0',
        'librosa>=0.10.0',
        'scipy>=1.10.0',
        'numpy>=1.24.0',
        'flask>=2.3.0',
        'pyzmq>=25.0.0',
        'tqdm>=4.65.0',
        'requests>=2.31.0',
    ],
)

