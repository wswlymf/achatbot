#!/bin/bash
# Start benchmark container and run throughput test
# with 1 2 4 8 thread of size 1 2 4 8 test set. (both needs to be integer)
# Retreve result back as .csv and .png

docker rm achatbot
docker run -td --privileged --name achatbot achatbot

# first run throughput test
for thread in 1 2 4 8
do
	for size in 1 2 4 8
	do
		docker exec achatbot /app/throughput.sh $size $thread
		docker cp achatbot:/app/result-$size-$thread-IPC.png ./result/
		docker cp achatbot:/app/result-$size-$thread-MPKI.png ./result/
		docker cp achatbot:/app/result-$size-$thread.csv ./result/
	done
done

# then run latency test
LA_SIZE="200"
docker exec achatbot /app/latency.sh $LA_SIZE
docker cp achatbot:/app/result-$LA_SIZE-latency.png ./result/
docker cp achatbot:/app/result-$LA_SIZE-latency.csv ./result/

docker stop achatbot