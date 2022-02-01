# prefix ?= /usr/local
prefix ?= /opt/homebrew
# intel_brew_path = /usr/local/bin/brew
# m1_brew_path = /opt/homebrew/bin/brew
# # Export Homebrew variables for current platform
# if [[ -x "$m1_brew_path" ]]; then
#     eval "$($m1_brew_path shellenv)"
# elif [[ -x "$intel_brew_path" ]]; then
#     eval "$($intel_brew_path shellenv)"
# fi

bindir = $(prefix)/bin
libdir = $(prefix)/lib
buildroot = $(shell swift build -c release --show-bin-path)

configure:
	echo "let DEFAULT_PLUGIN_LOCATION=\"$(libdir)/libXCGrapherModuleImportPlugin.dylib\"" > Sources/xcgrapher/Generated.swift

build: configure
	xcrun swift build -c release --disable-sandbox -Xlinker -rpath -Xlinker "$(libdir)"

install: build
	# Seems like brew hasn't created this yet and it confuses 'install' so...
	mkdir -p "$(bindir)"
	mkdir -p "$(libdir)"
	# Install the binary
	install "$(buildroot)/xcgrapher" "$(bindir)"
	# Install the libs
	install "$(buildroot)/libXCGrapherPluginSupport.dylib" "$(libdir)"
	install "$(buildroot)/libXCGrapherModuleImportPlugin.dylib" "$(libdir)"
	install_name_tool -change "$(buildroot)/libXCGrapherPluginSupport.dylib" "$(libdir)/libXCGrapherPluginSupport.dylib" "$(bindir)/xcgrapher"

uninstall:
	rm -rf "$(bindir)/xcgrapher"
	rm -rf "$(libdir)/libXCGrapherPluginSupport.dylib"
	rm -rf "$(libdir)/libXCGrapherModuleImportPlugin.dylib"

lint:
	swiftlint --autocorrect .
	swiftlint .
	swiftformat .

clean:
	rm -rf .build
	rm Sources/xcgrapher/Generated.swift

.PHONY: build install uninstall clean configure
