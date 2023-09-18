SHELL = /bin/sh
.SETUP_SCRIPTS: all

all: delete_by_date create_service restart_service zomboid

delete_by_date: ./scripts/delete_by_date.sh
		sudo cp ./scripts/delete_by_date.sh /usr/bin/delete_by_date
create_service: ./scripts/create_service.sh
		sudo cp ./scripts/create_service.sh /usr/bin/create_service
restart_service: restart_service_completion ./scripts/restart_service.sh 
		sudo cp ./scripts/restart_service.sh /usr/bin/restart_service 
restart_service_completion: ./completions/_restart_service
		sudo cp ./completions/_restart_service /home/$(USER)/.oh-my-zsh/completions/_restart_service
zomboid: zomboid_completition ./scripts/zomboid.cpp
		sudo g++ ./scripts/zomboid.cpp -o /usr/bin/zomboid
zomboid_completition: ./completions/_zomboid
		sudo cp ./completions/_zomboid /home/$(USER)/.oh-my-zsh/completions/_zomboid