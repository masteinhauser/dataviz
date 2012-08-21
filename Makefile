.PHONY: deploy watch clean touch
project=dataviz
path=/usr/src/${project}
instance=\033[36;01m${project}\033[m

all: watch
deploy: server = root@mylessteinhauser.com -p 2222
deploy:
	@coffee -c app.coffee
	@echo -e " ${instance} | stopping app on ${server}"
	-ssh ${server} "stop ${project}"
	@echo -e " ${instance} | stopped app on ${server}"
	@echo -e " ${instance} | deploying app on ${server}"
	@rsync -az --exclude=".git" --exclude="node_modules/*/build" --delete --delete-excluded * ${server}:${path}
	@echo -e " ${instance} | deployed app to ${server}"
	@ssh ${server} "cd ${path} && npm rebuild"
	@echo -e " ${instance} | built npm packages on ${server}"
	@ssh ${server} "sudo cp -f ${path}/upstart.conf /etc/init/${project}.conf"
	@echo -e " ${instance} | setting up upstart on ${server}"
	@echo -e " ${instance} | starting app on ${server}"
	@ssh ${server} "start ${project}"
	@echo -e " ${instance} | started app on ${server}"
	@make -s clean
	@sleep 1
	@make -s touch

touch: server = mylessteinhauser.com/${project}
touch:
	@wget -r -l 1 -q http://${server}
	@echo -e " ${instance} | built main assets on ${server}"
	@wget -r -l 1 -q http://${server}/clicker
	@echo -e " ${instance} | built clicker assets on ${server}"
	@rm -rf mylessteinhauser.com*

watch:
	@if ! which supervisor > /dev/null; then echo "supervisor required, installing..."; npm install supervisor; fi
	@supervisor -w assets,views,app.coffee app.coffee

clean:
	@rm app.js
	@echo -e " ${instance} | cleaned"
