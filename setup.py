from setuptools import setup
import subprocess

setup(name='RNAseqV2',
      version='2.0',
      description='RNAseq Processing',
      author='Jeremy Pardo',
      author_email='mezeg39@gmail.com',
      packages=['RNAseqV2'],
      install_requires=['distutils',
                'distutils.command',
                'datetime',
                'argparse',
                'pandas',
                'numpy',
                'dateparser',
                'json',
                'subprocess',
                'os'],)
subprocess.run(["bash", "./INSTALL.sh"])