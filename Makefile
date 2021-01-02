
build: ## build the simulation file for gtkwave	
	@ echo $(shell date)
	iverilog -g2005 *.v -o simout
	vvp -n simout
