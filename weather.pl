#!/usr/bin/env perl

# weather.pl

use strict;
use warnings;
use local::lib;
use LWP::Simple;
use JSON::XS;

use Data::Dumper;

# wunderground api query settings
my $api_key = '';
my $state = 'TX';
my $city = 'Cypress';

# query wunderground and store data
my $alerts = decode_json execute_api_query('alerts');
my $forecast = decode_json execute_api_query('forecast');

# get specific data out of hashes
my ($conditions, $high, $low, $humidity, $wind_speed) = (0,0,0,0,0);
#my $conditions = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->{'conditions'};
#my $high = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->{'high'}->{'fahrenheit'};
#my $low = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->{'low'}->{'fahrenheit'};
#my $humidity = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->{'avehumidity'};
#my $wind_speed = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->{'avewind'}->{'mph'};

# get keys (testing)
print "[testing]\n";
my @keys = keys($forecast->{'forecast'}->{'simpleforecast'}->{'forecastday'});
print "keys in \$forecast: " . "@keys\n";
print "data in \$forecast->{'forecast'}->{'simpleforecast'}->{'forecastday'}: " . "$forecast->{'forecast'}->{'simpleforecast'}->{'forecastday'}" . "\n";
print "\n";

# print out data
print "weather for $city, $state\n" .
      "currently: $conditions\n" .
      "high: $high F\n" .
      "low: $low F\n" .
      "humidity: $humidity %\n" .
      "wind speed: $wind_speed mph\n";

# subs
sub execute_api_query {
    my $function = $_[0];
    my $uri = "http://api.wunderground.com/api/$api_key/$function/q/$state/$city.json";
    my $results = get($uri);
    if (! $results) {
        die 'api query returned null';
    } else { 
        return $results;
    }
}
