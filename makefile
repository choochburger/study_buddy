all: haml coffeescript javascripts stylesheets favicon

haml:
	haml ./src/haml/index.haml ./www/index.html

coffeescript:
	coffee -o ./www/javascripts/ -c ./src/coffeescript/

stylesheets:
	cp -R ./src/stylesheets/ ./www/stylesheets/

javascripts:
	cp -R ./src/lib/ ./www/javascripts/
	cp -R ./src/javascripts/ ./www/javascripts/

favicon:
	cp ./src/favicon.ico ./www/

clean:
	rm -rf ./www/*
