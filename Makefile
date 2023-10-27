PROGRAM=vector3d
SHARED_LIB_NAME=lib$(PROGRAM)
OUTPUT=test

INCLUDE_OPENCV=-I/usr/include/opencv4/
#INCLUDE_STAR=-I/home/serl/STAR/AutonomousRobots/Libraries/star/include

build: $(OUTPUT)
	mkdir -p output
	cp $(SHARED_LIB_NAME).so ./output/$(SHARED_LIB_NAME).so
	mkdir -p ./output/include
	cp $(PROGRAM).h ./output/include/$(PROGRAM).h

$(OUTPUT): $(SHARED_LIB_NAME).so $(PROGRAM).h main.cpp
	g++  -o $(OUTPUT) main.cpp -L./ -L/home/serl/STAR/AutonomousRobots/Libraries/star/lib/ -l$(PROGRAM) -lopencv_core $(INCLUDE_OPENCV)

$(SHARED_LIB_NAME).so: $(PROGRAM).o
	g++ -shared -fPIC -o $(SHARED_LIB_NAME).so $(PROGRAM).o  -L/usr/local/cuda/lib64 -lcuda -lcudart

$(PROGRAM).o: $(PROGRAM).cu $(PROGRAM).h
	nvcc -c -Xcompiler -fPIC $(PROGRAM).cu

clean:
	rm -f $(PROGRAM).o $(SHARED_LIB_NAME).so *.obj $(OUTPUT)