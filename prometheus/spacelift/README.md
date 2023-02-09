# Spacelift Prometheus

This is a deployment to support the promex project from Spacelift <https://github.com/spacelift-io/prometheus-exporter>. The exporter reports the billing information and provides a target allowing Prometheus to scrape the data. This also includes Grafana, which is then used to provide a dashboard view of the data.

All the individual components are running in Docker making this extremely portable.

## Prometheus Setup

This is a very simple, almost stock deployment of prometheus. There is a `prometheus.yml` file which contains the configuration to scrape the promex project. Aside from that, everything else is stock. Check the `docker-compose.yml` file for more details regarding where to place the `prometheus.yml` file.

Once up and running, you can navigate to the prometheus containers ports and verify targets are up and running.

## Promex

The details regarding this project are located here: <https://github.com/spacelift-io/prometheus-exporter>. It is well documented and easy to setup. The `docker-compose.yml` references the variables which are required to run this application. This is exposed on port 9953 and you can check the status of the metrics page to confirm functionality.

## Dashboard

There is a pre-configured dashboard provided by Spacelift included in this repo - the original project is also in the Spacelift github. This dashboard was slightly modified for the values in the contract when building this.

## Setup

