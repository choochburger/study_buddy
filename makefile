JS=./www/javascripts/
COFFEE=./src/coffee_script/

all: haml coffeescript javascripts stylesheets favicon

haml:
	haml ./src/haml/index.haml ./www/index.html

coffeescript:
	coffee -o $(JS) -c $(COFFEE)

stylesheets:
	cp ./src/stylesheets/* ./www/stylesheets

javascripts:
	cp ./src/lib/* ./www/javascripts/
	cp ./src/javascripts/* ./www/javascripts/

favicon:
	cp ./src/favicon.ico ./www/

clean:
	rm -rf ./www/*
