NAME=accent-directories
DOMAIN=taiwbi.com

.PHONY: all pack install clean

all: dist/extension.js

node_modules: package.json
	npm install

dist/extension.js dist/prefs.js: node_modules
	tsc

schemas/gschemas.compiled: schemas/org.gnome.shell.extensions.accent-directories.gschema.xml
	glib-compile-schemas schemas/

$(NAME).zip: dist/extension.js dist/prefs.js schemas/gschemas.compiled
	@cp metadata.json dist/
	@cp -r schemas dist/
	@cp -r icons dist/
	@(cd dist && zip ../$(NAME)@$(DOMAIN).zip -9r .)

pack: $(NAME).zip

install: $(NAME).zip
	@rm -rf ~/.local/share/gnome-shell/extensions/$(NAME)@$(DOMAIN)
	@mv dist ~/.local/share/gnome-shell/extensions/$(NAME)@$(DOMAIN)

clean:
	@rm -rf dist node_modules $(NAME)@$(DOMAIN).zip