#!/usr/bin/env perl

# weather.pl
# github.com/renderorange/weather

use strict;
use warnings;

use local::lib;
use Getopt::Long;
use File::Slurper 'read_lines';
use LWP::Simple;
use JSON::XS;

# process commandline options
my ($zip, $forecast, $help);
GetOptions ( "z|zip=i" => \$zip,
             "f|forecast" => \$forecast,
             "h|help" => \$help );
if ($help) { help(); }

# look for and read rc file
if (! -e '.weather.rc') {
    die ".weather.rc is not present\n" .
        "please see github.com/renderorange/weather for setup details\n\n";
}

# load and verify config
my %config;
foreach (read_lines('.weather.rc')) {
    if (/^#|^ /) { next; }  # filter out comments and blank lines
    my ($key, $value) = split (/:/);  # store key and value pairs
    # trim whitespace
    $key =~ s/^\s+|\s+$//g;    # [TODO] this here isn't very elegant
    $value =~ s/^\s+|\s+$//g;  # I tried to use map on the split list above, but it didn't like modifying $_
    # verify config contains what's expected
    if ($key !~ /^api_key$/ || $value !~ /^\w+$/) {
        die ".weather.rc doesn't appear to contain what's needed\n" .
            "please see github.com/renderorange/weather for setup details\n\n";
    }
    $config{$key} = $value;  # $config{'api_key'} = wunderground key is accessed like so
}

# get current zip
my $geolocation_hash;
if (! $zip) {  # if zip isn't set by the user, get the information from geolocation
    $geolocation_hash = decode_json get('http://ip-api.com/json');
    $zip = $geolocation_hash->{'zip'};
}

# get and set city and state
my $location_hash = decode_json get("http://api.wunderground.com/api/$config{'api_key'}/geolookup/q/$zip.json");
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
print "\n";

# subs
sub help {
    die "usage: ./weather.pl -z 77429 -f\n\n" .
          "options:\n" .
          "\t--zip\t\tspecify where you want weather results for\n" .
          "\t\t\twithout --zip, weather.pl performs a geolookup to find where you are\n\n" .
          "\t--forecast\tadditionally displays the next 4 day forecast\n\n" .
          "\t--help\t\tdisplays this dialogue\n\n";
}

sub execute_wunderground_query {  # [TODO] update this to run all API queries
    my $function = $_[0];
    my $uri = "http://api.wunderground.com/api/$config{'api_key'}/$function/q/$state/$city.json";
    my $results = get($uri);
    if (! $results) {
        die "api query returned null\n";
    } else { 
        return $results;
    }
}
