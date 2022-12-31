CC = iverilog

main:
	$(CC) -o CPU.out *.v

vvp:
	vvp CPU.out

gtk:
	gtkwave CPU.vcd

clean:
	rm -f CPU.out CPU.vcd
