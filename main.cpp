#include <iostream>
#include <vector>
#include <sstream>

using namespace std;

int dx[8] = {-1, -1, -1, 0, 1, 1, 1, 0};
int dy[8] = {-1, 0, 1, 1, 1, 0, -1, -1};
int m, n;



int result = INT32_MAX;

void BFS(int prev_val, int count, int x, int y, vector<vector<bool>>& used, vector<vector<int>>& grid) {
	if (count + grid[x][y] >= result) return;  // 剪枝：当前路径代价已经超过最优，不必继续

	if (x == m - 1 && y == n - 1) {
		result = min(result, count + grid[x][y]);
		return;
	}

	for (int i = 0; i < 8; ++i) {
		int nx = x + dx[i];
		int ny = y + dy[i];
		if (nx >= 0 && ny >= 0 && nx < m && ny < n && !used[nx][ny]) {
			used[nx][ny] = true;
			if (grid[nx][ny] != prev_val) {
				BFS(grid[nx][ny], count + grid[nx][ny], nx, ny, used, grid);
			} else {
				BFS(grid[nx][ny], count, nx, ny, used, grid);
			}
			used[nx][ny] = false;
		}
	}
}


int main() {

	cin >> m >> n;
	vector<vector<int>> grid(m, vector<int>(n));
	for (int i = 0; i < m; ++i)
		for (int j = 0; j < n; ++j)
			cin >> grid[i][j];

	vector<vector<bool>> used(m, vector<bool>(n, false));
	used[0][0] = true;
	BFS(grid[0][0], 0, 0, 0, used,grid);

	cout << result << endl;

	return 0;
}