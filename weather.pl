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

# query wunderground, decode, then store and retrieve data
my $conditions = decode_json execute_api_query('conditions');
my $forecast = decode_json execute_api_query('forecast');

# output
print "weather for $city, $state\n" .
      "\n" .
      "currently:  $conditions->{'current_observation'}->{'weather'}\n" .
      "temp:  $conditions->{'current_observation'}->{'temperature_string'}\n" .
      "humidity:  $conditions->{'current_observation'}->{'relative_humidity'}\n" .
      "precip:  $conditions->{'current_observation'}->{'precip_today_string'}\n" .
      "wind:  $conditions->{'current_observation'}->{'wind_string'}\n" .
      "visibility:  $conditions->{'current_observation'}->{'visibility_mi'} miles\n" .
      "\n" .
      "forecast for:\n" .
      "$forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[0]{'title'}\n" .
      "    AM: $forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[0]{'fcttext'}\n" .
      "    PM: $forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[1]{'fcttext'}\n" .
      "$forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[2]{'title'}\n" .
      "    AM: $forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[2]{'fcttext'}\n" .
      "    PM: $forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[3]{'fcttext'}\n" .
      "$forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[4]{'title'}\n" .
      "    AM: $forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[4]{'fcttext'}\n" .
      "    PM: $forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[5]{'fcttext'}\n" .
      "$forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[6]{'title'}\n" .
      "    AM: $forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[6]{'fcttext'}\n" .
      "    PM: $forecast->{'forecast'}->{'txt_forecast'}->{'forecastday'}->[7]{'fcttext'}\n" .
      "\n";

# testing
#print "\n";
#print "[testing]\n";
#print "dumper output for \$forecast\n";
#print Dumper $forecast;
#print "\n";

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
