#!/usr/bin/env perl

# weather.pl

use strict;
use warnings;
use Getopt::Long;
use local::lib;
use LWP::Simple;
use JSON::XS;

use Data::Dumper;

# process commandline options
my ($forecast, $help);
GetOptions ( "forecast" => \$forecast,
             "help" => \$help );
if ($help) { help(); }

# wunderground api query settings
my $api_key = '';
my $state = 'TX';
my $city = 'Cypress';

# query wunderground, decode, then store and retrieve data
my ($conditions_hash, $forecast_hash);
$conditions_hash = decode_json execute_api_query('conditions');
if ($forecast) { $forecast_hash = decode_json execute_api_query('forecast'); }

# output
print "weather for $city, $state\n" .
      "\n" .
      "currently:  $conditions_hash->{'current_observation'}->{'weather'}\n" .
      "temp:  $conditions_hash->{'current_observation'}->{'temperature_string'}\n" .
      "humidity:  $conditions_hash->{'current_observation'}->{'relative_humidity'}\n" .
      "precip:  $conditions_hash->{'current_observation'}->{'precip_today_string'}\n" .
      "wind:  $conditions_hash->{'current_observation'}->{'wind_string'}\n" .
      "visibility:  $conditions_hash->{'current_observation'}->{'visibility_mi'} miles\n" .
      "\n";
if ($forecast) { 
    print "forecast for:\n" .
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

# testing
#print "\n";
#print "[testing]\n";
#print "dumper output for \$forecast\n";
#print Dumper $forecast;
#print "\n";

# subs
sub help {
    die "usage: ./weather.pl\n" .
          "-f|--forecast\tdisplay 4 day forecast\n" .
          "-h|--help\tdisplays this dialogue\n" .
          "\n";
}

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
