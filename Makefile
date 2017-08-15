
all:
	make get-plexmediaserver
	make get-plexurl
	make get-myflix
	make run-plexmediaserver

get-plexmediaserver:
	rm -rf pms-docker
	git clone https://github.com/eyedeekay/pms-docker
	cd pms-docker && \
	docker build -t pms-docker-complex .

run-plexmediaserver:
	cd pms-docker && \
	docker run \
		--rm \
		-d \
		--name plex \
		-e TZ="Amercia/Detroit" \
		-e ADVERTISE_IP="http://127.0.0.1:32400/" \
		-e PLEX_CLAIM="" \
		-h plex-complex \
		-p 32400/tcp \
		-p 3005/tcp \
		-p 8324/tcp \
		-p 32469/tcp \
		-p 1900/udp \
		-p 32410/udp \
		-p 32412/udp \
		-p 32413/udp \
		-p 32414/udp \
		-v config:/config \
		-v trancode:/transcode \
		-v MoImg:/home/myflix/myflix/MoImg \
		-v Movies:/home/myflix/myflix/Movies \
		-v TV:/home/myflix/myflix/TV \
		-v TVimg:/home/myflix/myflix/TVimg \
		plexinc/pms-docker

export-pms:
	docker export plex -o plex.tar.gz

get-plexurl:
	rm -rf plexurl
	git clone https://github.com/eyedeekay/plexurl
	cd plexurl && \
	docker build -t plexurl-complex .

export-plexurl:
	docker export plexurl-complex -o plexurl.tar.gz

run-plexurl:
	docker run -d --rm -p 8080:8080 --name plexurl-complex -t plexurl-complex

get-myflix:
	rm -rf myflix
	git clone https://github.com/eyedeekay/myflix
	cd myflix && \
	docker build -t myflix-complex .

run-myflix:
	cd myflix && \
	make docker-run


garbage-collect:
	docker system prune -f

clean:
	docker rm -f plex ; \
	docker rmi plexinc/pms-docker ; \
	make garbage-collect; \
	rm *.tar.gz

stop:
	docker stop plex
