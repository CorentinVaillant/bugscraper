
all_debug :
	make midi_lib_debug
	@echo "make debug done !"


all_release midi_lib_release:
	make midi_lib_release
	@echo "make release done !"

midi_lib_debug :
	
	cd lib/midi_input_handler && make debug


midi_lib_release :
	
	cd lib/midi_input_handler && make release TARGET=Linux
	cd lib/midi_input_handler && make release TARGET=Windows_NT #!WIP
	#!pain in the ass, no way I am doing this !# cd lib/midi_input_handler && make release TARGET=Darwin 

	
clean :
	cd lib/midi_input_handler && make clean

run :
	midi_lib_debug
	love .