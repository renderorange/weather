# weather
get cha some weather from wunderground

## description
weather.pl is a script to get current conditions and 4 day forecast from wunderground's API.

## setup
to run weather.pl, you'll need to first get a wunderground API key, from here: [https://www.wunderground.com/weather/api][wunderground]

then, to use the key, weather.pl expects a file named .weather.rc present in the same directory it resides.

like this...
```
~/scripts/weather $ ls -1a
weather.pl
.weather.rc
```

inside the .weather.rc file, weather.pl expects a key value pair, separated by colon, containing your wunderground api key.

like so...
```
$ cat .weather.rc 
# weather.pl settings
api_key:1a2s3d4f5g6h7j8k
```
warning, not a real key ^

weather.pl is a little forgiving with formatting of the rc file, but will let you know if something isn't right.

## usage
```
$ perl weather.pl -h
usage: ./weather.pl -z 77429 -f

options:
	--zip		specify where you want weather results for
				without --zip, weather.pl performs a geolookup to find where you are

	--forecast	additionally displays the next 4 day forecast

	--help		displays this dialogue
```

weather.pl only has two options other than the help dialogue.

run without any options, weather.pl will do a geolookup to [http://ip-api.com/json][ipapi] to match your outbound IP to related zip code.

if you're running through a proxy, the geolocation API call won't be accurate.
```
$ perl weather.pl 
weather for Houston, TX

currently:  Clear
temp:  68.8 F (20.4 C)
humidity:  88%
precip:  0.00 in (0 mm)
wind:  Calm
visibility:  10.0 miles
```

you can also specify where you want to check weather, using the --zip, or -z
```
$ perl weather.pl -z 37421
weather for Chattanooga, TN

currently:  Partly Cloudy
temp:  59.7 F (15.4 C)
humidity:  52%
precip:  0.00 in (0 mm)
wind:  Calm
visibility:  10.0 miles
```

if you would like a 4 day forecast, you can also specify --forecast, or -f
```
$ perl weather.pl -z 28734 -f
weather for Franklin, NC

currently:  Clear
temp:  44.4 F (6.9 C)
humidity:  68%
precip:  0.00 in (0 mm)
wind:  Calm
visibility:  10.0 miles

4 day forecast
Saturday
    AM: Sunny. High 71F. Winds E at 5 to 10 mph.
    PM: A mostly clear sky. Low 38F. Winds light and variable.
Sunday
    AM: A mainly sunny sky. High 76F. Winds light and variable.
    PM: Clear. Low near 40F. Winds light and variable.
Monday
    AM: Mainly sunny. High 81F. Winds light and variable.
    PM: Mainly clear skies. Low 46F. Winds light and variable.
Tuesday
    AM: Partly cloudy skies during the morning hours will become overcast in the afternoon. High 79F. Winds light and variable.
    PM: Partly cloudy skies. Low 48F. Winds light and variable.
```

## uncopyright
this script is specifically [uncopyrighted][uncopyright].

No permission is needed to copy, distribute, or modify any part. Credit isn't required.

Do what feels right, but don’t do it out of obligation.

Yeah, it's kind of hipster.  Fight the power, and all that.

I'll probably change it again something soon, but it's late and I need to go home and go to sleep.

[wunderground]: https://www.wunderground.com/weather/api
[ipapi]: http://ip-api.com/json
[uncopyright]: http://zenhabits.net/uncopyright
