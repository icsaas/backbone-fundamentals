include_dir=build
source=chapters/*.md
title='Developing Backbone.js Applications'
filename='backbone-fundamentals'


all: html epub rtf pdf mobi

markdown:
	awk 'FNR==1{print ""}{print}' $(source) > $(filename).md

html: markdown
	pandoc -s $(filename).md -f markdown+smart -t html5 -o index.html -c style.css \
		--include-in-header $(include_dir)/head.html \
		--include-before-body $(include_dir)/author.html \
		--include-before-body $(include_dir)/share.html \
		--include-after-body $(include_dir)/stats.html \
		--title-prefix $(title) \
		--toc

epub: markdown
	pandoc -s $(filename).md -f markdown+smart -t epub -o $(filename).epub \
		--epub-metadata $(include_dir)/metadata.xml \
		--css epub.css \
		--epub-cover-image img/cover.jpg \
		--title-prefix $(title) \
		--toc

rtf: markdown
	pandoc -s $(filename).md -f markdown+smart -o $(filename).rtf \
		--title-prefix $(title)

pdf: markdown
	# You need `pdflatex`
	# OS X: http://www.tug.org/mactex/
	# Then find its path: find /usr/ -name "pdflatex"
	# Then symlink it: ln -s /path/to/pdflatex /usr/local/bin
	pandoc -s $(filename).md -f markdown+smart -o $(filename).pdf \
		--title-prefix $(title) \
		--toc \
		--pdf-engine=xelatex

mobi: epub
	# Download: http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765211
	# Symlink bin: ln -s /path/to/kindlegen /usr/local/bin
	kindlegen $(filename).epub
