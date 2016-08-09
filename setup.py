from setuptools import setup

name = "xonshpiration"

setup(
    name=name,
    version="0.0.1",
    license="MIT",
    url="https://github.com/Carreau/xonshpiration",
    description="Either you are typing really, really fast, or it's a xonshpiration ",
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    author="Matthias Bussonnier",
    author_email="bussonniermatthias@gmail.com",
    zip_safe=False,
)
