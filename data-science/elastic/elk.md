# ELK

## Goals

* APM
* Ad-hoc tructured log analysis (errors, anomalies, insights)
* Alerting
* Anomaly detection over structured log events
  * Specific counts of log messages / values over time (FP estimates by metro)

## Overview

Shipt currently uses:

* Graphite / Grafana
  * Metrics
* NewRelic
  * APM (Rails)
* Scalyr
  * Structured logging
* Rollbar
  * Alerting


## Features

### Beats (Send)

* Modules (beats) for log shipping known formats to elastic. (i.e., Kafka, Postgres, k8s)
* `libbeat` foundation for building custom beats.

## Logstash (Transform)

Processing pipeline for ingesting, transforming, and publishing data. Used to
clean incoming beats data before sending it to elastic.

* Setup custom "ETL" jobs / cleansing.
* Example: Anonymize PII data

## Kibana (Visualize)

* ML Anomaly detection 👍🏻 🥳
  * Trends over time
  * Calendars to limit false positives (overnight?)

* Similar alerting to Scalyr 🤷🏻‍♂️
  * Set thresholds, send alerts

* Lenz - slick drag/drop chart builder 🎉
  * Good for exploratory analysis to ultimately create dashboards.

* Interactive dashboards (nice) 🙂
  * Ability to define filter criteria (by metro / all metros)

* Alerts are based on a JS function - so we could get fancy on alert detection. 🤔

## Elastic (Store)

Lucene based search engine. All fields are indexed.