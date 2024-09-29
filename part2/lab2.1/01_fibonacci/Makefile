# schoolRISCV program Makefile
#
# Stanislav Zhelnio, 2020
#

# default target to run when make is called without args
help:
	$(info make help     - show this message (default))
	$(info make clean    - delete folder with simulation data)
	$(info make rars     - run RISC-V CPU simulator)
	$(info make build    - create .hex program image)
	$(info make board    - copy .hex to boards/program)
	@true

# common targets

# make clean
#  delete all compilation products & folder with simulation data
clean:
	rm -rf sim
	rm -f *.elf *.dis *.mem *.hex

# make rars
#  java -jar ../common/rars1_4.jar & - run rars1_4.jar application using java machine
#									   in background
RARS = java -jar ../common/rars1_6.jar
rars:
	$(RARS) &

#########################################################
# software build
build: clean program.hex

# make program.hex - compile to hex memory image using RARS
#  java -jar ../common/rars1_4.jar nc a dump .text HexText program.hex main.S
#    java -jar ../common/rars1_4.jar - run rars1_4.jar application using java machine
#    nc                              - copyright notice will not be displayed
#    a                               - assemble only, do not simulate
#    dump .text HexText program.hex  - dump segment .text to program.hex file in HexText format
program.hex: main.S
	$(RARS) nc a dump .text HexText program.hex main.S

# make board - copy to board
#  copies program.hext to board/program where is will be searched with synthesis tools
board: program.hex
	cp ./program.hex ../../../part3/lab3.1/src/cpu