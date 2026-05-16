# Emergency Surge Backend Observability with Azure Monitor / Application Insights

This README explains the Azure Monitor / Application Insights instrumentation added to the Node.js backend.

This file is backend-scoped. It does not replace the main platform/evidence README.

The main platform repository tells the full Azure delivery story. This README explains how the backend participates in the observability stage.

## Purpose

The backend was not only deployed and load-tested. It was also instrumented so the running Node.js application could emit request telemetry into Azure Monitor / Application Insights.

This allowed the project to capture:

- AKS backend request telemetry
- request duration
- success/failure status
- KQL query results
- P50/P95 request duration evidence
- backend role instance evidence from the AKS pod

## Instrumentation Strategy

The backend uses a separate startup bootstrap file:

```text
src/instrumentation.js
```

The instrumentation is intentionally separated from `server.js`.

`server.js` remains focused on:

- Express startup
- middleware registration
- route creation
- request logging
- not-found handling
- global error handling
- graceful shutdown
- simulated collapse/recovery behavior

The telemetry bootstrap is loaded before the server starts through Node's `--import` option in `package.json`.

## Instrumentation Behavior

The instrumentation checks for:

```text
APPLICATIONINSIGHTS_CONNECTION_STRING
```

When the variable exists, the backend initializes Azure Monitor OpenTelemetry export and enables Live Metrics.

When the variable does not exist, the backend still starts normally and logs that Application Insights was not initialized.

This makes the backend safe to run locally without Azure configuration, while still allowing full telemetry when deployed to AKS.

## Instrumentation File

The backend telemetry bootstrap follows this pattern:

```js
import { useAzureMonitor } from '@azure/monitor-opentelemetry';

const connectionString = process.env.APPLICATIONINSIGHTS_CONNECTION_STRING;

if (connectionString) {
  useAzureMonitor({
    azureMonitorExporterOptions: {
      connectionString
    },
    enableLiveMetrics: true
  });

  console.log('Azure Monitor Application Insights initialized');
} else {
  console.log('Azure Monitor Application Insights not initialized: connection string not found');
}
```

## Package Startup

The backend startup script was updated so instrumentation loads before the Express server:

```json
"start": "node --import ./src/instrumentation.js src/server.js"
```

This was important because telemetry has to be initialized before the application begins handling requests.

## Dockerfile Mitigation

A key issue appeared during AKS validation.

The backend worked locally with Application Insights, but AKS telemetry did not appear at first.

The cause was the Dockerfile.

The Dockerfile was originally starting the application directly:

```dockerfile
CMD ["node", "src/server.js"]
```

That bypassed `npm start`, which meant `src/instrumentation.js` was never preloaded inside the container.

The fix was:

```dockerfile
CMD ["npm", "start"]
```

After that change, the container used the package startup script and loaded the instrumentation bootstrap correctly.

## Kubernetes Secret Configuration

The Application Insights connection string was stored in Kubernetes as a Secret and injected into the backend deployment as an environment variable.

The important environment variable is:

```text
APPLICATIONINSIGHTS_CONNECTION_STRING
```

This keeps the telemetry connection string out of source code and allows the same backend image to run with or without Azure telemetry depending on environment configuration.

## AKS Validation

After the Dockerfile and Kubernetes Secret wiring were fixed, the backend image was rebuilt, pushed to Azure Container Registry, and redeployed to AKS Dev.

The AKS pod logs confirmed:

```text
Azure Monitor Application Insights initialized
Emergency surge API listening on port 4001
```

Then fresh backend traffic was generated against:

```text
/health
/loadtest/ping
```

## Application Insights Evidence

Application Insights / Azure Monitor showed request telemetry from the AKS backend.

Evidence captured included:

- AKS pod role instance
- `GET /loadtest/ping`
- public backend URL
- HTTP 200 result code
- success = true
- request duration
- KQL request table output

## KQL Percentile Evidence

The KQL query summarized request telemetry by route/name and calculated:

- request count
- average duration
- P50 duration
- P95 duration
- failure count

This produced proof that the backend emitted useful runtime telemetry from inside AKS.

## What This Stage Proves

This stage proves that:

- the Node.js backend can be instrumented with Azure Monitor OpenTelemetry
- telemetry initialization can be safely controlled through an environment variable
- AKS can inject the Application Insights connection string through a Kubernetes Secret
- Docker startup must preserve the instrumentation preload path
- Application Insights can capture AKS backend request telemetry
- KQL can be used to analyze P50/P95 request duration and failures

## Code Highlights

Backend areas worth reviewing:

- `src/instrumentation.js`
- `package.json` startup scripts
- Dockerfile startup command
- health endpoint
- `/loadtest/ping` endpoint
- request logging middleware
- correlation/request ID handling
- collapse/recovery simulation logic

## Public Narrative Guidance

Good public wording:

```text
The backend was instrumented with Azure Monitor OpenTelemetry and deployed to AKS with the Application Insights connection string injected through a Kubernetes Secret. KQL queries then confirmed AKS request telemetry, P50/P95 duration, and zero failures for the test traffic.
```

Avoid implying that this is a full enterprise observability platform.

This is a focused MVP observability proof.
