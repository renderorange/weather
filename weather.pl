#!/usr/bin/env perl

# weather.pl

use strict;
use warnings;
use Getopt::Long;
use LWP::Simple;
use JSON::XS;

# process commandline options
my ($zip, $current, $forecast, $help);
GetOptions ( "z|zip=i" => \$zip,
             "c|current" => \$current,
             "f|forecast" => \$forecast,
             "h|help" => \$help );
if (! $zip || $help) { help(); }
if ($current || $forecast) { 
    eval 1;  # find more elegant way to do this
} else {
    help();
}

# wunderground api settings
my $api_key = '';
if (! $api_key) {
    print "api key not set\n";
    exit;
}

# get location data for zip
my $locations_hash = decode_json get("http://api.wunderground.com/api/$api_key/geolookup/q/$zip.json");
my $city = $locations_hash->{'location'}->{'city'};
my $state = $locations_hash->{'location'}->{'state'};

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
          "required\n" .
          "  -z|--zip\tpostal code of the location to check\n" .
          "\n" .
          "optional (either -c or -f must be passed)\n" .
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
