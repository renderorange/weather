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
             "c|current" => \$current,
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
my ($geolocation_hash, $city, $state);
if (! $zip) {  # if zip isn't set by the user, get the information from geolocation
    $geolocation_hash = decode_json get('http://ip-api.com/json');
    $zip = $geolocation_hash->{'zip'};
    $city = $geolocation_hash->{'city'};
    $state = $geolocation_hash->{'regionName'};
} else {
    $geolocation_hash = decode_json get("http://ip-api.com/json?$zip");  # not sure of the format
    $city = $geolocation_hash->{'city'};
    $state = $geolocation_hash->{'regionName'};
}

# query wunderground, decode, then store data
my ($conditions_hash, $forecast_hash);
if ($current) { $conditions_hash = decode_json execute_api_query('conditions'); }
if ($forecast) { $forecast_hash = decode_json execute_api_query('forecast'); }

# output
print "weather for $city, $state\n\n";
if ($current) {
    print "currently:  $conditions_hash->{'current_observation'}->{'weather'}\n" .
          "temp:  $conditions_hash->{'current_observation'}->{'temperature_string'}\n" .
          "humidity:  $conditions_hash->{'current_observation'}->{'relative_humidity'}\n" .
          "precip:  $conditions_hash->{'current_observation'}->{'precip_today_string'}\n" .
          "wind:  $conditions_hash->{'current_observation'}->{'wind_string'}\n" .
          "visibility:  $conditions_hash->{'current_observation'}->{'visibility_mi'} miles\n" .
          "\n";
}
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
    die "usage: ./weather.pl -z 77429 -c -f\n\n" .
          "options (-c or -f must be used)\n" .
          "  -z|--zip\tpostal code of the location to check\n" .
          "  -c|--current\tdisplays current conditions\n" .
          "  -f|--forecast\tdisplays 4 day forecast\n" .
          "  -h|--help\tdisplays this dialogue\n" .
          "\n";
}

sub execute_api_query {
    my $function = $_[0];
    my $uri = "http://api.wunderground.com/api/$api_key/$function/q/$state/$city.json";
    my $results = get($uri);
    if (! $results) {
        die "api query returned null\n";
    } else { 
        return $results;
    }
}
