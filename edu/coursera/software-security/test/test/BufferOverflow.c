//
//  BufferOverflow.c
//  test
//
//  Created by Damon Allison on 10/16/15.
//  Copyright © 2015 Recursive Awesome. All rights reserved.
//

#include "BufferOverflow.h"

char *foo(char *buf) {

    printf("sizeof == %lu\n", sizeof(buf));
    printf("len == %lu\n", strlen(buf));

    char *x = buf+strlen(buf);
    char *y = buf;
    while (y != x) {
        if (*y == 'a')
            break;
        y++;
    }
    return y;
}
/**
 * Call this with "authX" where "X" can be anything non-zero.
 */
void overflowAuth(char *arg1) {

    char input[10] = "leonard";
    char * ret = foo(input);

    printf("sizeof == %lu\n", sizeof(ret));
    printf("len == %lu\n", strlen(ret));

    int authenticated = 0;
    char buffer[4];

    strcpy(buffer, arg1); // overflow happens here : no bounds checking.

    if (authenticated) {
        printf("pwned\n");
    }

}
