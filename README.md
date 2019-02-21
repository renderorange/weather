# weather

cli program to get the weather for your location

## SYNOPSIS

```
weather [--current]
        [--forecast]
        [--version]
        [--help] [--man]
        [--devel] [--debug]
```

## DESCRIPTION

This program will retrieve weather condition and forecast details for your location.

## OPTIONS

```
--current     print the current conditions
--forecast    print the 5 day forecast
--version     print the version and exit
--help        print this dialogue
--man         display the full documentation
--devel       use a development tier key for openweathermap
--debug       dump the internals and query responses
```

## EXAMPLES

### get the current conditions

```
weather --current
```

### get the current conditions and 5 day forecast

```
weather --current --forecast
```

## CONFIGURATION

The configuration file for weather is located in the homedir of the running user, named .weatherrc

The file may contain two sections, production and development, under the parent section, openweathermap.

```
~ $ cat .weatherrc
[openweathermap]
production = 1q2w3e4r5t6y7u8i9o0p1q2w3e4r5t6y
development = 0p9o8i7u6y5t4r3e2w1q0p9o8i7u6y5t
```

The development section is required in the case of using the --devel switch for weather.

The production section is required in normal operation.

## DEPENDENCIES

- Getopt::Long
- Pod::Usage
- Config::Tiny
- HTTP::Tiny
- JSON::MaybeXS
- Data::Dumper
- Time::Piece

## AUTHOR

Blaine Motsinger, <blaine@renderorange.com>

## LICENSE AND COPYRIGHT

This software is available under the MIT license.

Copyright (c) 2019 Blaine Motsinger
