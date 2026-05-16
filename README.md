# Emergency Surge Azure Delivery Evidence Package

Welcome.

This repository is the main evidence trail for the Emergency Surge Azure MVP delivery package.

It documents how a healthcare-related Emergency Surge supervisor dashboard scenario was taken through Azure platform provisioning, container deployment, runtime validation, observability, cost estimation, and cleanup.

This is not only an Infrastructure-as-Code repository.

It is the main walkthrough for the end-to-end Azure delivery story.

## Scenario

One of our healthcare-related clients asked for an MVP with a Node.js backend that could be deployed, tested, and monitored using Azure-native tools.

The MVP was based on a hypothetical Emergency Surge system: a supervisor dashboard designed to simulate operational pressure scenarios and support the evaluation of Node.js and Azure as backend/platform choices for a later production implementation.

This public MVP is a recreated demo version based on the delivery scenario. It contains no client data or confidential assets.

## What This Evidence Package Proves

The objective was to deliver an evidence package showing that the proposed Azure architecture worked end to end:

- application deployment to Azure
- backend and frontend containerization
- Terraform-based infrastructure provisioning
- logical Dev, QA, and Prod separation
- image publishing through Azure Container Registry
- AKS runtime execution
- Azure-native load testing
- Application Insights / Azure Monitor telemetry
- KQL-based P50/P95 request evidence
- cost estimation, actual spend review, and cleanup

## Technology Stack

The delivery package uses:

- GitHub
- Azure DevOps
- Terraform
- Azure Container Registry
- Azure Kubernetes Service
- Docker
- Node.js
- Angular
- Azure Load Testing
- Application Insights
- Azure Monitor
- KQL
- Azure Pricing Calculator
- Azure Cost Management

## How to Read This Repository

This repository is meant to be read as a delivery journey.

Recommended path:

1. Platform Foundation
   - Terraform
   - Azure resource group
   - Azure Container Registry
   - Azure Kubernetes Service
   - AKS namespaces
   - deployment foundations

2. Runtime Proof
   - current Dev backend/frontend proof
   - `/health`
   - `/loadtest/ping`
   - Azure Load Testing
   - AKS/container logs

3. Observability
   - Azure Monitor / Application Insights
   - Node.js OpenTelemetry instrumentation
   - Kubernetes Secret-based configuration
   - AKS backend request telemetry
   - KQL P50/P95 evidence

4. Cost Discipline
   - Azure Cost Management actual spend
   - Azure Pricing Calculator estimate
   - estimate vs actual comparison
   - resource group cleanup after evidence capture

## What Should I Read Next?

If you are not familiar with Terraform, start with `docs/1_START_HERE/2_Terraform-explained.md` before continuing.

This repository is organized as a guided evidence trail. If you are reviewing the project for the first time, use the following reading order.

### 1. Start with the High Overview

Read:

```text
docs/1_Start_here/1_STEP_BY_STEP_HIGH_OVERVIEW_CHECKLIST.txt
```

This file explains the full project expectation and final state after completing the MVP delivery work.

It summarizes the Azure DevOps, GitHub, Terraform, AKS, ACR, runtime validation, observability, KQL, Pricing Calculator, Cost Management, and cleanup evidence.

It also explains an important timeline distinction:

- historical Dev -> QA -> Prod -> rollback/recovery evidence
- current rebuilt Dev evidence used for Azure Load Testing, Application Insights, KQL, and cost-control proof
- final Azure resource cleanup after evidence capture

This is the best starting point to understand the whole delivery package before going into technical details.

### 2. Read the Historical Execution Guide

Read:

```text
docs/1_START_HERE/3_STEP_BY_STEP_IN_DETAIL_INITIAL_GUIDE_CHECKLIST.txt
```

This file captures the earlier full execution journey in detail.

It explains the original Azure DevOps, GitHub, Terraform, AKS, Dev, QA, Prod, rollback/recovery, and remote Terraform state work.

This guide is valuable because it preserves the real operational path, including decisions, corrections, mistakes, mitigations, and environment-promotion evidence.

### 3. Review the Platform Foundation Guide

Read:

```text
docs/2_PLATFORM_FOUNDATION_TERRAFORM_AKS_ACR/STEP_BY_STEP_AKS_IN_DETAIL_CHECKLIST.txt
```

This file focuses on the Terraform + AKS + ACR foundation.

It explains how the Azure platform was created, how AKS was validated, how namespaces were prepared, and how the infrastructure foundation unlocked the later deployment and runtime evidence.

### 4. Review the Runtime Proof Guide

Read:

```text
docs/3_RUNTIME_PROOF_AZURE_LOAD_TESTING/STEP_BY_STEP_SRE_APP_IN_DETAIL_CHECKLIST.txt
```

This file explains the SRE/runtime validation stage.

SRE stands for Site Reliability Engineering.

In practical terms, it means applying software engineering practices to keep systems:

- reliable
- observable
- scalable
- recoverable
- measurable


It covers the `/health` endpoint, the dedicated `/loadtest/ping` endpoint, Azure Load Testing, AKS service validation, backend logs, request volume, throughput, error percentage, and runtime evidence from the deployed Dev backend.

This is where the project moves from:

```text
the app was deployed
```

to:

```text
the app was exercised, measured, and verified
```

### 5. Review the Observability Notes

Read:

```text
docs/4_OBSERVABILITY_APPLICATION_INSIGHTS/AZURE_MONITOR_APPLICATION_INSIGHTS.md
```

This file explains how Azure Monitor / Application Insights was added to the Node.js backend.

It covers the OpenTelemetry instrumentation file, `package.json` startup preload, the Dockerfile correction, Kubernetes Secret configuration, AKS pod validation, Application Insights request telemetry, and KQL-based request analysis.

This is where the project proves backend observability from inside AKS.

### Brief Note on P50 and P95

In the Application Insights / KQL evidence, P50 and P95 are used to summarize backend request duration.

- **P50** means the median request duration: 50% of requests were faster than this value.
- **P95** means the 95th percentile request duration: 95% of requests were faster than this value, while the slowest 5% were above it.

P50 gives a sense of typical behavior. P95 helps expose slower tail-latency behavior that averages can hide.



### 6. Review the Cost Discipline Package

Read:

```text
docs/5_COST_DISCIPLINE_PRICING_CALCULATOR/1_STEP_BY_STEP_APCALC_HIGH_OVERVIEW_CHECKLIST.txt
docs/5_COST_DISCIPLINE_PRICING_CALCULATOR/2_STEP_BY_STEP_APCALC_IN_DETAIL_CHECKLIST.txt
docs/5_COST_DISCIPLINE_PRICING_CALCULATOR/3_AZURE_PRICING_CALCULATOR_NARRATIVE.txt
```

These files explain the Azure Pricing Calculator and Cost Management stage.

They document the actual Azure cost, forecast, cost by service, cost by resource group, cost by resource, estimated monthly architecture cost, and cleanup after evidence capture.

This stage is where the project proves cost-awareness: the Azure platform was not just built, tested, and observed. It was also estimated, reviewed, and decommissioned responsibly.

### 7. Review the Screen Captures

After reading the documents, review the matching screenshots:

```text
ScreenCaptures/1_PLATFORM_FOUNDATION_TERRAFORM_AKS_ACR/
ScreenCaptures/2_RUNTIME_PROOF_AZURE_LOAD_TESTING/
ScreenCaptures/3_OBSERVABILITY_APPLICATION_INSIGHTS/
ScreenCaptures/4_COST_DISCIPLINE_PRICING_CALCULATOR/
```

The screenshots are the visual evidence trail behind the written guides.

They show Azure Portal, Terraform output, AKS state, ACR tags, Azure Load Testing results, Application Insights/KQL telemetry, Cost Management views, Pricing Calculator estimate, and final cleanup evidence.

### 8. Then Review the Application Repositories

After reviewing this platform/evidence repository, it is recommended to read the application repository READMEs:

```text
node-mrgc-api
ng-mrgc-ui
```

The backend README explains the Node.js simulation service, queue/outcome model, collapse/recovery behavior, structured logging, `/loadtest/ping`, and Azure Monitor / Application Insights instrumentation.

The frontend README explains the Angular supervisor dashboard, the Emergency Surge UI concept, queue-based visual model, outcome categories, offline/critical mode, and the product reasoning behind the supervisor-facing experience.

Together, the three repositories tell the full story:

- this repository explains the Azure delivery evidence
- the backend repository explains the simulation service and observability hooks
- the frontend repository explains the supervisor dashboard and product-facing experience

The goal is to make the review feel like following the delivery journey from the developers' perspective: architecture, implementation, setbacks, deployment, runtime validation, observability, cost control, and final evidence packaging.

Hope you enjoy reviewing the journey as much as we enjoyed building and documenting it.

## Suggested Repository Structure

```text
infra/
  terraform/

docs/
  1_START_HERE/
  2_PLATFORM_FOUNDATION_TERRAFORM_AKS_ACR/
  3_RUNTIME_PROOF_AZURE_LOAD_TESTING/
  4_OBSERVABILITY_APPLICATION_INSIGHTS/
  5_COST_DISCIPLINE_PRICING_CALCULATOR/

ScreenCaptures/
  1_PLATFORM_FOUNDATION_TERRAFORM_AKS_ACR/
  2_RUNTIME_PROOF_AZURE_LOAD_TESTING/
  3_OBSERVABILITY_APPLICATION_INSIGHTS/
  4_COST_DISCIPLINE_PRICING_CALCULATOR/
```

## Main Evidence Areas

### 1. Platform Foundation

This stage proves that the Azure platform foundation was created and validated.

Evidence includes:

- Terraform validation/plan/apply
- Azure resource group creation
- Azure Container Registry creation
- AKS cluster creation
- AKS namespace creation
- kubectl access
- ACR image tags
- backend/frontend deployment evidence

### 2. Runtime Proof

This stage proves that the deployed application was exercised and verified.

Evidence includes:

- public backend health endpoint
- dedicated `/loadtest/ping` endpoint
- Azure Load Testing setup
- Azure Load Testing result summary
- client-side latency evidence
- AKS backend logs showing request traffic

### 3. Observability

This stage proves that the Node.js backend running in AKS emitted telemetry into Application Insights / Azure Monitor.

Evidence includes:

- Azure Monitor/OpenTelemetry instrumentation
- Kubernetes Secret configuration
- Dockerfile correction to load the instrumentation bootstrap
- Application Insights request telemetry
- KQL query results
- P50/P95 request duration evidence
- zero-failure request summary

### 4. Cost Discipline

This stage proves that cost was not ignored after the technical work.

Evidence includes:

- Azure Cost Management actual cost
- cost grouped by service
- cost grouped by resource group
- cost grouped by resource
- Azure Pricing Calculator estimate
- comparison between actual short-lived spend and full-month estimate
- deletion of project resource groups after evidence capture

## Important Timeline Note

The project contains both historical lifecycle evidence and current rebuilt environment evidence.

Historical lifecycle evidence:

- Dev deployment
- QA deployment
- Prod deployment
- rollback/recovery proof

Current rebuilt Dev evidence:

- current Dev runtime proof
- Azure Load Testing
- Application Insights telemetry
- KQL P50/P95
- Azure Pricing Calculator
- Cost Management cleanup

The distinction is intentional. It keeps the evidence honest after Azure resources were deleted and recreated for cost-control reasons.

## Current Azure Environment Status

The Azure environment used for evidence capture is no longer active.

The main platform resource group, AKS managed resource group, and Terraform state resource group were deleted after the evidence and cost screenshots were captured.

This was intentional cost-control cleanup.

## Related Repositories

This repository is the main platform/evidence entry point.

Related application repositories:

- Frontend repository: Angular supervisor dashboard
- Backend repository: Node.js Emergency Surge API

Those repositories explain the application-specific frontend and backend design. This repository explains the Azure delivery, runtime evidence, observability evidence, and cost-control story.

## What This Repository Is Not

This is not a production hospital system.

This is not a full enterprise SRE platform.

This is not a pure DevOps-only portfolio project.

It is an end-to-end delivery evidence package showing how the MVP was containerized, provisioned, deployed, tested, observed, cost-reviewed, and cleaned up.

## Final Delivery Value

This repository demonstrates a Senior IC backend/full-stack delivery profile with practical Azure runtime and observability capability:

- backend ownership
- cloud deployment awareness
- Kubernetes runtime validation
- Azure-native observability
- load testing discipline
- cost-control awareness
- evidence-based documentation

The goal was simple:

Prove the platform.

Prove the runtime behavior.

Prove observability.

Prove cost discipline.
