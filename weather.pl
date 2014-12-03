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
my ($high, $low, $humidity, $wind_speed) = (0,0,0,0,0);
my $conditions = $forecast->{'forecast'}->{'simpleforecast'}->{'forecastday'}->[0]{'conditions'};
#my $high = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->[0]{'high'}->{'fahrenheit'};
#my $low = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->[0]{'low'}->{'fahrenheit'};
#my $humidity = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->[0]{'avehumidity'};
#my $wind_speed = $forecast{'forecast'}->{'simpleforecast'}->{'forecastday'}->[0]{'avewind'}->{'mph'};

# testing
print "[testing]\n";
print "dumper output for \$forecast->forecast->simpleforecast->forecastday->[0]{high}->{'fahrenheit'}\n";
print Dumper "$forecast->{'forecast'}->{'simpleforecast'}->{'forecastday'}->[0]{'high'}->{'fahrenheit'}";
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