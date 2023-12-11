PANOPTS=--standalone \
	--table-of-contents \
	--css=main.css \
	--section-divs \
	--email-obfuscation=references \
	--include-after-body=footer.html \
	--include-before-body=header.html

%.ico: %.png
	convert png:$< ico:$@
	@chmod 644 $@

%.html: %.md | main.css footer.html header.html
	pandoc $(PANOPTS) --from=markdown --to=html --output=$@ $<
	@chmod 644 $@

all: $(patsubst %.md,%.html,$(wildcard *.md)) favicon.ico sitemap.xml
	@echo Check permissions, then use make push to upload.

footer.html: footer.md | main.css
	pandoc --from=markdown --to=html --output=$@ $<
	@chmod 644 $@

header.html: header.md | main.css
	pandoc --from=markdown --to=html --output=$@ $<
	@chmod 644 $@

sitemap.xml: $(patsubst %.md,%.html,$(wildcard *.md))
	./gensitemap.sh > $@
	@chmod 644 $@

clean:
	rm -f *.html sitemap.xml