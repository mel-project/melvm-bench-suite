mvm_add:
	time melorun ./melvm-benches/add.melo

c_add:
	gcc -O0 -o c-benches/add.out c-benches/add.c
	time ./c-benches/add.out
