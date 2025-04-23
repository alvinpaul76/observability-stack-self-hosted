# Observability Stack (Self-Hosted)

A comprehensive self-hosted observability stack for monitoring applications and infrastructure. This stack includes log aggregation, metrics collection, visualization, and alerting capabilities.

## Components

### Core Services

- **Grafana**: Web-based visualization platform (port 3000)
- **Prometheus**: Time-series database for metrics storage and querying (port 9090)
- **Loki**: Log aggregation system with components:
  - Loki Gateway (NGINX): Entry point for Loki requests (port 8080)
  - Loki Read: Handles read operations (3 replicas)
  - Loki Write: Handles write operations (3 replicas)
  - Loki Backend: Handles background operations and rule evaluation
- **Promtail**: Log collection agent that ships logs to Loki
- **MinIO**: S3-compatible object storage for Loki data (ports 9000/9001)

### Supporting Services

- **Metrics Exporter**: Custom service that converts logs to Prometheus metrics (port 8082)
- **Log Generator**: Test service that generates sample logs (for development only)

## Storage

The stack uses local storage volumes for persistence:
- Prometheus data: `/storage/observability/prometheus`
- Grafana data: `/storage/observability/grafana`
- Alertmanager data: `/storage/observability/grafana/alertmanager-data`
- MinIO data: `/storage/observability/minio/data`
- Loki data: `/storage/observability/loki`

## Configuration

Configuration files are stored in the `config` directory:
- `alertmanager.yml`: Alertmanager configuration
- `datasources.yaml`: Grafana datasource configuration
- `loki.yaml`: Loki configuration
- `nginx.conf`: NGINX configuration for Loki Gateway
- `prometheus.yaml`: Prometheus configuration
- `promtail.yaml`: Promtail configuration

## Alerting Rules

Alerting rules are defined in the `rules` directory:
- `rules/docker/rules.yml`: Docker-specific alerting rules

## Dashboards

A pre-configured Grafana dashboard is provided in `grafana-dashboard.json`.

## Getting Started

1. Ensure Docker and Docker Compose are installed
2. Create the required storage directories
3. Run the stack with:
   ```
   docker-compose up -d
   ```
4. Access Grafana at http://localhost:3000
5. Access Prometheus at http://localhost:9090
6. Access MinIO console at http://localhost:9001 (credentials: loki/supersecret)

## Development

The `scripts` directory contains:
- `log_to_metrics.py`: Script for converting logs to metrics
- `Dockerfile`: For building the metrics exporter container
