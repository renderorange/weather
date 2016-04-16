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

currently:  Mostly Cloudy
temp:  77.0 F (25.0 C)
humidity:  81%
precip:  0.00 in (0 mm)
wind:  From the WNW at 2.0 MPH Gusting to 11.0 MPH
visibility:  10.0 miles

```

you can also specify where you want to check weather, using the --zip, or -z

```
$ perl weather.pl -z 37421

weather for Chattanooga, TN

currently:  Partly Cloudy
temp:  69.8 F (21.0 C)
humidity:  32%
precip:  0.00 in (0 mm)
wind:  Calm
visibility:  10.0 miles

```

if you would like a 4 day forecast, you can also specify --forecast, or -f

```
$ perl weather.pl -z 28734 -f

weather for Franklin, NC

currently:  Clear
temp:  61.1 F (16.2 C)
humidity:  47%
precip:  0.00 in (0 mm)
wind:  Calm
visibility:  10.0 miles

4 day forecast

Saturday
AM:  Sunny. High 73F. Winds light and variable.
PM:  A clear sky. Low 37F. Winds light and variable.

Sunday
AM:  Mainly sunny. High 77F. Winds light and variable.
PM:  A mostly clear sky. Low near 40F. Winds light and variable.

Monday
AM:  Mostly sunny skies. High 81F. Winds light and variable.
PM:  A few clouds. Low 46F. Winds light and variable.

Tuesday
AM:  A mix of clouds and sun in the morning followed by cloudy skies during the afternoon. High around 80F. Winds light and variable.
PM:  Partly cloudy. Low near 50F. Winds light and variable.

```

## unlicense

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>

[wunderground]: https://www.wunderground.com/weather/api
[ipapi]: http://ip-api.com/json
[unlicense]: http://unlicense.org
