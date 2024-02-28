## Apache Bench Script

### Usage
```
./ab.sh {url}
```

### Description
This script runs Apache Bench (`ab`) on a specified URL.

### Functionality
- The script starts with 1 concurrency and 2 connections, doubling each iteration.
- If failed requests are returned, the script stops.
- Each iteration of the script is written to `{connections}_{concurrency}.txt`.

### Example
```
./ab.sh http://example.com
```

This will execute Apache Bench on `http://example.com`, starting with 1 concurrency and 2 connections. The results of each iteration will be saved to `{connections}_{concurrency}.txt`.
