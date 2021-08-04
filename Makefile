.PHONY : build # 按 release 构建
build:
	mkdir -p build/release
	cd build/release \
	&& cmake -DCMAKE_BUILD_TYPE=Release \
	   ../.. \
	&& make -j2

.PHONY : build-debug # 按 debug 构建
debug:
	mkdir -p build/debug
	cd build/debug \
	&& cmake -DCMAKE_BUILD_TYPE=Debug \
	   ../.. \
	&& make -j2

.PHONY : clean # 删除构建目录
clean:
	rm -rf build
