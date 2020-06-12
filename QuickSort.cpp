#include <iostream>

void quicksort(int* a, int left, int right)
{
	if (left >= right)
		return;
	int i = left;
	int j = right;
	int v = a[(right + left) / 2];
	while (i<j)
	{
		while (a[i] < v) i++;
		while (a[j] > v) j--;
		if (i <= j)
		{
			std::swap(a[i], a[j]);
			i++;
			j--;
		}
	}
	quicksort(a, left, j);
	quicksort(a, i, right);
}

int main()
{
	int n = 0;
	std::cin >> n;
	int* a = new int[n];
	for (int i = 0; i < n; i++)
		std::cin >> a[i];
	quicksort(a, 0, n - 1);
	for (int i = 0; i < n; i++)
		std::cout << a[i] << " ";
	return 0;
}