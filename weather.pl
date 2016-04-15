#!/usr/bin/env perl

# weather.pl

use strict;
use warnings;
use Getopt::Long;
use LWP::Simple;
use JSON::XS;

# [TODO]
# change geolookup to ip-api.com
#     this api finds current zip and returns geodata, including city and state
#     the point in switching, to speed up the multiple lookups to wunderground
#     since they have multiple levels of lookups, including verification of API key
#     I want to be able to streamline as much as I can here.
# investigate switching to weather.io
#     nah, let's stick with the non-hipster option here
# if you put this out on github, find a way to scrub your API string from the commits.

# process commandline options
my ($zip, $current, $forecast, $help);
GetOptions ( "z|zip=i" => \$zip,
             "f|forecast" => \$forecast,
             "h|help" => \$help );
if ($help) { help(); }

# wunderground api settings
my $api_key = '';
if (! $api_key) {
    print "api key not set\n";
    exit;
}

# get current zip
my $geolocation_hash;
if (! $zip) {  # if zip isn't set by the user, get the information from geolocation
    $geolocation_hash = decode_json get('http://ip-api.com/json');
    $zip = $geolocation_hash->{'zip'};
#    $city = $geolocation_hash->{'city'};
#    $state = $geolocation_hash->{'regionName'};
}

# get and set city and state
my $location_hash = decode_json get("http://api.wunderground.com/api/$api_key/geolookup/q/$zip.json");
my $city = $location_hash->{'location'}->{'city'};
my $state = $location_hash->{'location'}->{'state'};

# query wunderground, decode, then store data
my ($conditions_hash, $forecast_hash);
$conditions_hash = decode_json execute_wunderground_query('conditions');
if ($forecast) { $forecast_hash = decode_json execute_wunderground_query('forecast'); }

# output
print "weather for $city, $state\n\n" .
      "currently:  $conditions_hash->{'current_observation'}->{'weather'}\n" .
      "temp:  $conditions_hash->{'current_observation'}->{'temperature_string'}\n" .
      "humidity:  $conditions_hash->{'current_observation'}->{'relative_humidity'}\n" .
      "precip:  $conditions_hash->{'current_observation'}->{'precip_today_string'}\n" .
      "wind:  $conditions_hash->{'current_observation'}->{'wind_string'}\n" .
      "visibility:  $conditions_hash->{'current_observation'}->{'visibility_mi'} miles\n" .
      "\n";
if ($forecast) { 
    print "4 day forecast\n" .
          "$forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[0]{'title'}\n" .
          "    AM: $forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[0]{'fcttext'}\n" .
          "    PM: $forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[1]{'fcttext'}\n" .
          "$forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[2]{'title'}\n" .
          "    AM: $forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[2]{'fcttext'}\n" .
          "    PM: $forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[3]{'fcttext'}\n" .
          "$forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[4]{'title'}\n" .
          "    AM: $forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[4]{'fcttext'}\n" .
          "    PM: $forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[5]{'fcttext'}\n" .
          "$forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[6]{'title'}\n" .
          "    AM: $forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[6]{'fcttext'}\n" .
          "    PM: $forecast_hash->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[7]{'fcttext'}\n" .
          "\n";
}

# subs
sub help {
    die "usage: ./weather.pl -z 77429 -f\n\n" .
          "options:\n" .
          "\t--zip\t\tspecify where you want weather results for\n" .
          "\t\t\twithout --zip, weather.pl performs a geolookup to find where you are\n\n" .
          "\t--forecast\tadditionally displays the next 4 day forecast\n\n" .
          "\t--help\t\tdisplays this dialogue\n\n";
}

sub execute_wunderground_query {
    my $function = $_[0];
    my $uri = "http://api.wunderground.com/api/$api_key/$function/q/$state/$city.json";
    my $results = get($uri);
    if (! $results) {
        die "api query returned null\n";
    } else { 
        return $results;
    }
}
