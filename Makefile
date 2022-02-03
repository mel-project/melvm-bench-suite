all_mvm: mvm_add mvm_c25519_mul

mvm_add:
	time melorun ./melvm-benches/add.melo

mvm_c25519_mul:
	time melorun ./melvm-benches/curve25519_mul.melo

c_add:
	gcc -O0 -o c-benches/add.out c-benches/add.c
	time ./c-benches/add.out

c_c25519_mul:
	gcc -O0 -o c-benches/curve25519_mul.out c-benches/curve25519_mul.c
	time ./c-benches/curve25519_mul.out
