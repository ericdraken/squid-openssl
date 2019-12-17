
build:
	docker build -t ericdraken/squid-openssl:armv7 .

rebuild:
	docker build --no-cache -t ericdraken/squid-openssl:armv7 .