# weather

cli program to get the weather for your location

## SYNOPSIS

```
weather [--zip] <int>
        [--current] [--forecast]
        [--version]
        [--help] [--man]
```

## DESCRIPTION

This program will retrieve weather condition and forecast details for your location.

## OPTIONS

```
--zip         specify where you want weather results for
              geolocation lookup will be performed without zip
--current     print the current conditions
--forecast    print the next 4 day forecast
--version     print the version and exit
--help        print this dialogue
--man         display the full documentation
```

## EXAMPLES

### get the current conditions for a specified zip code

```
weather --zip 77095 --current
```

### get the current conditions and 4 day forecast

```
weather --zip 77095 --current --forecast
```

### get the 4 day forecast only, via geolocation

```
weather --forecast
```

## DEPENDENCIES

- Getopt::Long
- Pod::Usage

## AUTHOR

Blaine Motsinger, <blaine@renderorange.com>
