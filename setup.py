# -*- coding: utf-8 -*-

from setuptools import setup, find_packages

with open('README.rst', 'r') as f_readme:
    long_desc = f_readme.read()

requires = ['Sphinx>=4.0.0', 'Pygments>=2.0.1', 'future>=0.16.0']

setup(
    name='Cylinder-based approximation of 3D objects',
    use_scm_version=True,
    setup_requires=['setuptools_scm<6.0.0'],
    url='https://github.com/GiovanniFilomeno/SoftwareLabCylModel',
    license='BSD',
    author='Ahmad M. Belbeisi',
    author_email='ahmadbelb@gmail.com',
    maintainer='Ahmad M. Belbeisi',
    maintainer_email='ahmadbelb@gmail.com',
    description='Cylinder-based approximation',
    long_description=long_desc,
    long_description_content_type='text/x-rst',
    zip_safe=False,
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Environment :: Web Environment',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Documentation',
        'Topic :: Utilities',
        'Framework :: Sphinx :: Extension'
    ],
    platforms='any',
    packages=find_packages(),
    include_package_data=True,
    install_requires=requires,
    namespace_packages=['sphinxcontrib'],
)
