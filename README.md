# Internet speed in European territorial units

The goal of this project is to create a [dashboard](https://datavis.europeandatajournalism.eu/obct/connectivity/) where people, but mainly journalists, can navigate the data for different territorial levels - from countries to cities - besides downloading them in a tabular format for reuse. Ultimately "opening" the data for non data-savvy professionals who might want to use this information.

![](https://datavis.europeandatajournalism.eu/obct/connectivity/files/screen_dash_2022.png)

## Data Sources

This projects combines two different open data sources:

- the internet performances data provided by [Speedtest](https://www.speedtest.net/) by [Ookla](https://registry.opendata.aws/speedtest-global-performance/) Global Fixed and Mobile Network Performance Maps, based on analysis by Ookla of Speedtest Intelligence data. Available through the library [`ooklaOpenDataR`](https://github.com/teamookla/ooklaOpenDataR);
- the geometries of European territorial units (local administrative units (LAU) and regions/districts (NUTS2/NUTS3)) distributed by [Eurostat](https://ec.europa.eu/eurostat/web/nuts/nuts-maps) for EU Member States, EU official candidate countries, and EFTA countries. Available through the library [`latlon2map`](https://github.com/giocomai/latlon2map).

## Analysis

The analysis consists in 5 steps, and as many scripts.

- `1-data_analysis.R` consists in a loop that downloads the raw data from Ookla and executes the geocomputation and tidying necessary to store the raw files as well the outputs of the analysis;
- `2-lau_nuts_matching.R` matches the European cities with their respective regions, as this is not something directly provided by Eurostat but it's needed for the comparisons we show in the dashboard;
- `3-maps.R` creates and saves interactive html maps with [`leaflet`](https://rstudio.github.io/leaflet/) for every NUTS2 region and country, as well as European maps;
- `4-density_plots.R` creates and saves static density plots useful to compare the internet speed distribution between a region, the country it is located, and Europe;
- `5-prepare_viz_for_dashboard.R` is used to uniform the encoding and clean the visualizations' names from white spaces and commas in order to properly show the elements in the dashboard.

## Data structure explanation

The data is provided by Ookla every quarter from Q1 2019. 
In the `data` folder is possible to download the datasets for every quarter since Q1 2019 for every territorial unit (`lau`, `nuts3`, `nuts2`, `nuts0`) as well as the time series for every territorial unit.

The data structure is common to every file, consisting in:
- `id`, the Eurostat id code of the territorial unit;
- `name`, the name of the territorial unit;
- `quarter`, the quarter to which the measurements refer to;
- `avg_d`, average download speed in megabit per second (Mbps);
- `avg_u`, average upload speed in megabit per second (Mbps);
- `avg_l`, average latency in milliseconds (ms).

## How to cite

This project is licensed under the Creative Commons Attribution 4.0 International (CC BY-SA 4.0).
To cite this project please refer to the [European Data Journalism Network](https://www.europeandatajournalism.eu/), as well as the data provider (Speedtest by Ookla Global Fixed and Mobile Network Performance Maps).
