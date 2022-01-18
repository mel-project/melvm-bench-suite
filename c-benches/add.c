#include <stdio.h>

int main () {
    int i,j,r=0;
    for (i = 0; i < 10000; i++) {
        for (j = 0; j < 10000; j++) {
            r = j + i;
        }
    }

    return 0;
}
