HAXE_MAIN=alkindi.Alkindi

help:
	@echo make test .... Run tests
	@echo make js ...... Generate javascript
	@echo make swc ..... Build the swc
	@echo make as3 ..... Generate actionscript 3
	@echo make clean ... Cleanup binaries

bin/alkindi.swc:
	@mkdir -p bin
	@./haxe -swf bin/alkindi.swc -dce no -cp src ${HAXE_MAIN}

bin/alkindi-as3:
	@mkdir -p bin
	@./haxe -as3 bin/alkindi-as3 -dce no -cp src ${HAXE_MAIN}

swc:
	@mkdir -p bin
	@./haxe -swf bin/alkindi.swc -dce no -cp src ${HAXE_MAIN}

as3:
	@mkdir -p bin
	@./haxe -as3 bin/alkindi-as3 -dce no -cp src ${HAXE_MAIN}

js:
	@mkdir -p bin
	@./haxe -js bin/alkindi.js -cp src ${HAXE_MAIN}

test:
	@./haxe -cp src -cp tests -main Main --interp

clean:
	rm -fr bin
