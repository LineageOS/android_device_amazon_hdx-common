all:	Cuber-boot Cuber-recovery

Cuber-boot:
	g++ -Wall -Wextra -Wno-unused-result -march=native -O2 -Iinclude cuber.cpp -o Cuber-boot -lcrypto

Cuber-recovery:
	g++ -Wall -Wextra -Wno-unused-result -march=native -O2 -Iinclude cuber.cpp -o Cuber-recovery -lcrypto

clean:
	rm Cuber-boot Cuber-recovery
