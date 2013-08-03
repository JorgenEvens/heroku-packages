# heroku-packages

These packages are to be used with [heroku-modular-buildpack](https://github.com/JorgenEvens/heroku-modular-buildpack).

You can use the repository hosting these packages with your buildpack, it is located at [http://jorgen.evens.eu/heroku/index](http://jorgen.evens.eu/heroku/index).

# Use Github as package hoster
You can use your own Github repo as hoster for you packages.
To do this just run the `create-index` script with parameter `https://raw.github.com/JorgenEvens/heroku-packages/master`.

>create-index https://raw.github.com/JorgenEvens/heroku-packages/master > index

And your `build/heroku/repos` files that you use in your project should look like this: 
>https://raw.github.com/JorgenEvens/heroku-packages/master/index

