BUILD_VCS_DIR = build_vcs
BUILD_XRUN_DIR = build_xrun
SRC_DIR = src

all: tdb_reader.a tdb_reader.so

tdb_reader.a: $(BUILD_VCS_DIR)/tdb_reader.o $(BUILD_VCS_DIR)/dpi_c_interface.o
	ar -r $@ $^

tdb_reader.so: $(BUILD_XRUN_DIR)/tdb_reader.o $(BUILD_XRUN_DIR)/dpi_c_interface.o
	g++ -fPIC -shared -o $@ $^

$(BUILD_VCS_DIR)/%.o: $(SRC_DIR)/%.cpp
	g++ -c -o $(BUILD_VCS_DIR)/$(notdir $@) $< -I/opt/synopsys/vcs2018/vcs/O-2018.09-SP2/include

$(BUILD_XRUN_DIR)/%.o: $(SRC_DIR)/%.cpp
	g++ -fPIC -c -o $(BUILD_XRUN_DIR)/$(notdir $@) $< -I/opt/cadence/xceliummain20.09/tools.lnx86/include

clean:
	rm -f *.o *.a
	rm -f $(BUILD_VCS_DIR)/*.o $(BUILD_VCS_DIR)/*.a
	rm -f $(BUILD_XRUN_DIR)/*.o $(BUILD_XRUN_DIR)/*.a
