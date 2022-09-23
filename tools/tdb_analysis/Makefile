BUILD_DIR = build
SRC_DIR = src
INCLUDE_DIR = ../tdb_reader/src

default: all

run: tdb_analysis.elf
	./$<

all: tdb_analysis.elf

tdb_analysis.elf: $(BUILD_DIR)/main.o $(BUILD_DIR)/tdb_reader/tdb_reader.o
	g++ -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	mkdir -p $(BUILD_DIR)
	g++ -c -o $(BUILD_DIR)/$(notdir $@) $< -I$(INCLUDE_DIR)

$(BUILD_DIR)/tdb_reader/%.o: ../tdb_reader/src/%.cpp
	mkdir -p $(BUILD_DIR)/tdb_reader
	g++ -c -o $(BUILD_DIR)/tdb_reader/$(notdir $@) $< -I$(INCLUDE_DIR)

clean:
	rm -rf $(BUILD_DIR)/*
