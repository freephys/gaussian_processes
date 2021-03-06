PYCMD=python setup.py
GH_PAGES_SOURCES=gp docs VERSION.txt README.md Makefile setup.py

all:
	$(PYCMD) bdist

source:
	$(PYCMD) sdist

upload:
	$(PYCMD) sdist upload

install:
	$(PYCMD) install

clean:
	$(PYCMD) clean --all
	rm -rf dist
	rm -f MANIFEST
	rm -f README
	rm -f *.pyc
	rm -f gp/ext/*.c
	rm -f gp/ext/*.so
	rm -rf *.egg-info
	rm -f .coverage
	rm -rf htmlcov
	rm -rf build

cython:
	$(PYCMD) build_ext --inplace

test:
	py.test --cov gp

gh-pages:
	make clean || true
	git checkout gh-pages
	rm -rf _sources _static _modules
	git checkout master $(GH_PAGES_SOURCES)
	git reset HEAD
	pandoc --from markdown --to rst -o README.rst README.md
	python setup.py build_ext --inplace
	make -C docs html
	mv -fv docs/_build/html/* .
	rm -rf $(GH_PAGES_SOURCES) README.rst build
	git add -A
	git ci -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`" && git push origin gh-pages
	git checkout master
