
all:
	make get-plexmediaserver
	make get-plexurl

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
		-e PLEX_CLAIM="" \
		-p 32400:32400 \
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
	git clone https://github.com/eyedeekay/myflix

garbage-collect:
	docker system prune -f

clean:
	rm *.tar.gz
