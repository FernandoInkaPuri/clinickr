
networking:
docker network create -d bridge clinickr

server:
	docker run	-v $(pwd):/app -v rubygems_clinickr:/usr/local/bundle -w /app -p 4567:4567 ruby bash -c "ruby csv_reader.rb -s puma"

install.gems:
	docker run -v rubygems_clinickr:/usr/local/bundle ruby bash -c "gem install sinatra puma byebug pg"

pg.server:
	docker run --rm --name clinickpg -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD='123456' -e POSTGRES_DB=postgres -v clinick_db_data:/var/lib/postgresql/data --network clinickr postgres
