volume:=seed_test
data:=/data
backup:=backup.tar

.PHONY: clean
clean:
	rm -rf ./data
	rm -f $(backup)
	docker volume rm $(volume)

.PHONY: seed
seed: # this creates a volume and puts something into it
	docker volume create $(volume) || true
	docker run --rm \
		-v $(volume):$(data) \
		-v $(CURDIR):/work \
		-w /work \
		alpine \
		./seed.sh

.PHONY: start
start: # start a container (foreground) using our seed volume
	docker run -it --rm \
		-v $(volume):$(data) \
		alpine \
		ping 1.1.1.1

.PHONY: export
export: # export the volume from the running container and save it as a Tarball
	$(eval CID = $(shell curl --unix-socket /var/run/docker.sock http://docker/containers/json | jq -r '.[0].Id'))
	curl \
		-o $(backup) \
		--unix-socket /var/run/docker.sock \
		http://docker/containers/$(CID)/archive?path=$(data)
