# Em Map
RShiny application that I built to celebrate Em's 365 days of running.

![alt text](https://github.com/andGarc/em_map/blob/main/docs/imgs/map_sample.png?raw=true)

## Description
I utilized a [Tile](https://www.tile.com/en-us) to track the location, which was then displayed on a custom map. Data was gathered from the Tile using the Tile API. A bash script was periodically triggered via CRON to initiate the data collection process. The map was custom built using [mapbox](https://www.mapbox.com). The final product was an RShiny app hosted on an AWS ECS2 instance, providing a live location feed for me to crew for Em as needed, and anyone with the link to track her progress. 

## Usage
This project is no longer being maintained.
