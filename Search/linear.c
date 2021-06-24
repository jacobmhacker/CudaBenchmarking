#include <stdio.h>
#include <stdlib.h>

int max_val(int* arr, int n) {
	int max = *(arr);

	for(int i = 1; i < n; i++) {
		if(*(arr + i) > max) {
			max = *(arr + i);
		}
	}

	return max;
}

/*
 * stdin takes the following inputs:
 *  - Array size
 *  - Array
 */

int main() {
	int n;
	int* arr;

	scanf("%d", &n);
	arr = (int*) malloc(sizeof(int) * n);

	for(int i = 0; i < n; i++) {
		scanf("%d", arr + i);
	}

	printf("Maximum value is: %d\n", max_val(arr, n));

	return 0;
}
