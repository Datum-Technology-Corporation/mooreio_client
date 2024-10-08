# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################


from setuptools import setup, find_packages


def parse_requirements(filename):
    with open(filename, 'r') as file:
        return [line.strip() for line in file if line.strip() and not line.startswith('#')]

setup(
    name="mio_client",
    version="2.0.0",
    description="CLI tool to automate EDA tasks for ASICs, FPGAs, and UVM IP.",
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    url="https://github.com/Datum-Technology-Corporation/mooreio_client",
    author="Datum Technology Corporation",
    author_email="info@datumtc.ca",
    license="MIT",
    packages=find_packages(),
    install_requires=parse_requirements('requirements.txt'),
    extras_require={
        'dev': parse_requirements('requirements-dev.txt')
    },
    classifiers=[
        "Programming Language :: Python :: 3.11",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    entry_points={
        "console_scripts": [
            "mio_client=mio_client.cli:main",
        ],
    },
    python_requires='>=3.11.4',
)