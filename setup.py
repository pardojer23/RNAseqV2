from setuptools import setup, find_packages
import subprocess

setup(name='RNAseqV2',
      version='2.0',
      description='RNAseq Processing',
      author='Jeremy Pardo',
      author_email='mezeg39@gmail.com',
      packages=find_packages(),
      install_requires=[
                'argparse',
                'pandas',
                'numpy',
                'dateparser'])
subprocess.run(["bash", "./INSTALL.sh"])