#include <stdio.h>
#include <stdlib.h>

__global__ void max_val(int* d_max, int* arr, int n) {
	int base = threadIdx.x * n;
	int max = *(arr + base);

	printf("In thread %d\n", threadIdx.x);

	for(int i = base + 1; i < base + n; i++) {
		if(*(arr + i) > max) {
			max = *(arr + i);
		}
	}

	*(d_max + threadIdx.x) = max;
}

/*
 * stdin takes the following inputs:
 *  - #threads
 *  - Array size
 *  - Array
 */

int main() {
	int n;
	int* arr;
	int* max;
	int* d_arr;
	int* d_max;

	int threads;

	scanf("%d", &threads);
	scanf("%d", &n);
	arr = (int*) malloc(sizeof(int) * n);
	max = (int*) malloc(sizeof(int) * threads);

	for(int i = 0; i < n; i++) {
		scanf("%d", arr + i);
	}

	cudaMalloc((void**) &d_arr, sizeof(int) * n);
	cudaMalloc((void**) &d_max, sizeof(int) * threads);
	cudaMemcpy(d_arr, arr, sizeof(int) * n, cudaMemcpyHostToDevice);

	max_val<<<1,threads>>>(d_max, d_arr, n / threads);

	cudaMemcpy(max, d_max, sizeof(int) * threads, cudaMemcpyDeviceToHost);

	int max_val = *(max);

	for(int i = 1; i < threads; i++) {
		if(max_val < *(max + i)) {
			max_val = *(max + i);
		}
	}

	printf("Maximum value is: %d\n", max_val);

	return 0;
}
