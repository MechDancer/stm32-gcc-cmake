.PHONY : build
build:
	mkdir -p build/release
	cd build/release \
	&& cmake -DCMAKE_BUILD_TYPE=Release \
			 -DCMAKE_CXX_COMPILER=/usr/bin/g++-11 \
	   ../.. \
	&& make -j2

.PHONY : build-debug
debug:
	mkdir -p build/debug
	cd build/debug \
	&& cmake -DCMAKE_BUILD_TYPE=Debug \
			 -DCMAKE_CXX_COMPILER=/usr/bin/g++-11 \
	   ../.. \
	&& make -j2

.PHONY : clean
clean:
	rm -rf build
