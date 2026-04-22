# Terraform-Explained

## What Terraform Is

Terraform is an **Infrastructure-as-Code** tool.

That means it lets you describe infrastructure in code so the system can create, update, and manage cloud resources in a repeatable way.

Instead of going into the Azure Portal and clicking manually to create resources one by one, Terraform lets you define those resources in `.tf` files.

In simple words:

- application code creates application behavior
- Terraform code creates infrastructure behavior

A useful mental model is:

> Terraform files are blueprints for cloud resources, written in a declarative language.

---

## What `.tf` Means

The `.tf` extension means:

**Terraform configuration file**

Examples:
- `main.tf`
- `variables.tf`
- `outputs.tf`
- `providers.tf`
- `versions.tf`

Terraform reads all `.tf` files in the same folder together as one configuration.

That means Terraform does **not** treat them like:
- first `main.tf`
- then `variables.tf`
- then `outputs.tf`

Instead, it loads the whole folder as one unit.

So splitting files is mostly for:
- readability
- organization
- maintainability

not for execution order.

---

## What `main.tf` Is

Usually, `main.tf` is where people place the actual infrastructure resources they want Terraform to manage.

In this project, `main.tf` contains the core Azure platform resources:

- Azure Resource Group
- Azure Container Registry, ACR
- Azure Kubernetes Service cluster, AKS
- role assignment so AKS can pull images from ACR

This makes `main.tf` the main infrastructure definition file for the platform.

---

## Example from `main.tf`

```hcl
resource "azurerm_resource_group" "platform" {
  name     = var.platform_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name       = "systemnp"
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
```

---

## Conceptual Explanation of Each Resource in `main.tf`

### 1. Azure Resource Group

```hcl
resource "azurerm_resource_group" "platform" {
  name     = var.platform_resource_group_name
  location = var.location
  tags     = var.tags
}
```

Meaning:
- create an Azure Resource Group
- use the AzureRM provider
- the internal Terraform label is `platform`
- use the values from variables for name, location, and tags

Why this exists:
Azure resources usually live inside a resource group.
This resource group becomes the logical container for the platform infrastructure.

---

### 2. Azure Container Registry, ACR

```hcl
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}
```

Meaning:
- create an Azure Container Registry
- use the name from variables
- place it in the platform resource group
- use the same Azure region
- use the Basic pricing tier
- do not enable the admin user
- apply tags

Why this exists:
Your frontend and backend will be built as Docker images.
Those images need to live somewhere.
ACR is the place where AKS will later pull those images from.

---

### 3. Azure Kubernetes Service, AKS

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags
```

Meaning:
- create an AKS cluster
- use the provided cluster name
- place it in the platform resource group
- use the same location
- set a DNS prefix
- optionally set a Kubernetes version
- apply tags

Why this exists:
AKS is the Kubernetes platform that will run the application workloads.

---

### 4. Default Node Pool

```hcl
  default_node_pool {
    name       = "systemnp"
    node_count = var.node_count
    vm_size    = var.vm_size
  }
```

Meaning:
- create the default node pool for the cluster
- give it the name `systemnp`
- set the number of nodes
- set the VM size

Why this exists:
AKS needs worker machines underneath it to run containers.
This block defines those base compute nodes.

---

### 5. Managed Identity

```hcl
  identity {
    type = "SystemAssigned"
  }
```

Meaning:
- let Azure assign a managed identity to the AKS cluster

Why this exists:
Managed identity is cleaner and safer than hardcoding credentials into the infrastructure.
It helps later when AKS needs permissions to interact with Azure resources.

---

### 6. Role-Based Access Control

```hcl
  role_based_access_control_enabled = true
```

Meaning:
- enable RBAC in the cluster

Why this exists:
Access control matters in Kubernetes, and this is a reasonable default for a serious platform setup.

---

### 7. Network Profile

```hcl
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}
```

Meaning:
- use Azure networking
- use Standard load balancer

Why this exists:
These are reasonable default choices for a cloud-hosted AKS environment.

---

### 8. Role Assignment So AKS Can Pull Images from ACR

```hcl
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
```

Meaning:
- grant AKS kubelet identity permission to pull images from ACR
- assign the `AcrPull` role
- scope that permission specifically to the ACR resource

Why this exists:
Without this permission, AKS may not be able to pull container images from the registry.

This is one of the most important pieces in the deployment chain.

---

## Should Terraform Files Be Created Manually?

Yes, but with an important nuance.

Terraform files are often written manually, but usually **not invented from nothing**.

People typically build them using:

- official provider documentation
- trusted examples
- starter templates
- company modules
- reference repos
- generated starting points that are then reviewed and adjusted

So “manual” usually means:

> assemble and adapt known Terraform patterns intentionally

not:

> write everything from memory like magic

---

## Are There Templates?

Yes.

Common sources of Terraform templates or examples are:

### 1. Official Terraform Provider Docs
Each resource type usually has examples.

For example:
- `azurerm_resource_group`
- `azurerm_container_registry`
- `azurerm_kubernetes_cluster`
- `azurerm_role_assignment`

### 2. Microsoft Azure Documentation
Azure docs often include example Terraform files for AKS and other services.

### 3. Community Repositories
Many teams and public examples show common patterns.

### 4. Internal Company Modules
In real teams, reusable Terraform modules are very common.

So yes, templates and examples are normal, expected, and good practice.

---

## Can “The System” Generate Terraform Automatically?

Partially, yes.

There are several ways Terraform can be generated or scaffolded:

### 1. AI / Code Assistants
AI tools can generate starter `.tf` files from requirements.

### 2. Existing Cloud Resources + Import
If resources already exist in Azure, Terraform can sometimes be introduced through:
- import
- reverse engineering
- exported templates used as reference

But even then, the `.tf` code still needs human review.

### 3. Starter Scaffolds
A person or system can generate a safe initial scaffold and then refine it.

That is effectively what happened here.

Important:
Even if Terraform is generated automatically, it still needs review for:
- naming
- cost
- permissions
- networking
- maintainability
- architectural correctness

---

## What Is the Standard Safe Technique?

The safest and most standard technique is:

### 1. Start Small
Do not try to model the whole cloud universe on day one.

Start with:
- resource group
- ACR
- AKS

Then later add:
- Key Vault
- monitoring
- advanced networking
- more role assignments
- extras

### 2. Split Files by Concern
A common pattern is:

- `versions.tf` -> Terraform and provider version rules
- `providers.tf` -> provider configuration
- `variables.tf` -> input variables
- `main.tf` -> resources
- `outputs.tf` -> useful outputs
- `backend.tf` -> remote state configuration
- `environments/*.tfvars` -> environment-specific values

This is exactly why the scaffold was structured that way.

### 3. Use Variables Instead of Hardcoding
This makes the config:
- cleaner
- more reusable
- easier to adapt across environments

### 4. Validate Before Applying
Run:
- `terraform fmt`
- `terraform validate`
- `terraform plan`

before:
- `terraform apply`

### 5. Use Remote State Later
For collaboration and safety, remote state is important.
That usually means:
- a storage account
- a state container
- backend configuration

### 6. Prefer Clear Naming and Small Increments
This is the safest pattern.
Clarity beats premature overengineering.

---

## Explanation of Every Folder and File in `mrgc-platform-iac`

## Repository Root: `mrgc-platform-iac/`

This is the root of the infrastructure repository.

Purpose:
hold infrastructure-only concerns.

That usually includes:
- Terraform
- infrastructure docs
- infrastructure architecture

---

## `README.md`

Purpose:
explain:
- what the repo is for
- why it exists separately
- what it contains
- how it fits into the platform

This should be the first orientation document for the repo.

---

## `infra/`

Purpose:
top-level folder for infrastructure code.

This is a common and safe convention.

---

## `infra/terraform/`

Purpose:
Terraform configuration lives here.

This is the actual IaC implementation folder.

---

## `infra/terraform/versions.tf`

Purpose:
pin Terraform and provider versions.

Typical content:
- minimum Terraform version
- AzureRM provider version

Why this matters:
it reduces version inconsistency across machines and environments.

---

## `infra/terraform/providers.tf`

Purpose:
configure the providers Terraform will use.

In this project:
- AzureRM provider

Why this matters:
Terraform needs to know which platform it will talk to.

---

## `infra/terraform/variables.tf`

Purpose:
declare input variables.

Typical examples:
- subscription ID
- location
- ACR name
- AKS cluster name
- node count
- VM size
- tags

Why this matters:
keeps configuration flexible and reusable.

---

## `infra/terraform/main.tf`

Purpose:
define the actual Azure resources.

In this project:
- resource group
- ACR
- AKS
- `AcrPull` role assignment

This is the core infrastructure description.

---

## `infra/terraform/outputs.tf`

Purpose:
return useful values after apply.

Typical examples:
- resource group name
- ACR login server
- AKS cluster name

Why this matters:
outputs are useful for:
- pipeline tasks
- documentation
- debugging
- follow-up configuration

---

## `infra/terraform/backend.tf.example`

Purpose:
template for remote Terraform state configuration.

Why `.example`:
because the remote state storage may not exist yet.

Later, once the state backend exists, this can become:
- `backend.tf`

Why this matters:
remote state is the standard safer way to manage Terraform state in shared or repeated workflows.

---

## `infra/terraform/environments/`

Purpose:
hold environment-specific value files.

This is a common Terraform pattern.

---

## `infra/terraform/environments/dev.tfvars`

Purpose:
values specific to Dev environment.

Examples:
- tags
- node count
- VM size
- location if needed

---

## `infra/terraform/environments/qa.tfvars`

Purpose:
values specific to QA environment.

---

## `infra/terraform/environments/prod.tfvars`

Purpose:
values specific to Prod environment.

Important nuance:
In the scaffold, these files are still very similar placeholders, which is completely fine at the beginning.

Later they may diverge more.

---

## `docs/`

Purpose:
infrastructure documentation.

Typical future content:
- deployment notes
- screenshot checklist
- Key Vault notes
- rollout/rollback notes
- Azure configuration notes

---

## `architecture/`

Purpose:
infrastructure architecture notes.

Typical future content:
- IaC diagrams
- AKS namespace strategy
- environment promotion flow
- pipeline/IaC relationship
- deployment architecture

---

## Standard Safe Generation Process for This Repo

A normal safe workflow looks like this:

### Step 1
Create the repo structure manually or from a scaffold.

### Step 2
Add starter `.tf` files from trusted examples.

### Step 3
Adjust names, variables, and values for the project.

### Step 4
Run locally:

```bash
terraform fmt
terraform validate
terraform plan
```

### Step 5
If the plan looks correct:

```bash
terraform apply
```

### Step 6
Later, move state to a remote backend.

This is a normal, safe, professional technique.

---

## Honest Assessment of the Current Scaffold

What exists right now is a **good starter scaffold**, not a finished enterprise-grade Terraform architecture.

That is exactly what it should be at this stage.

It is:
- understandable
- small
- clear
- easy to evolve

It is not yet:
- module-heavy
- deeply environment-isolated
- network-hardened
- enterprise-polished

And that is fine.

For this showcase, it is the right level of complexity for now.

---

## Best Mental Model

Think of Terraform files as:

> blueprints for Azure resources, written in a declarative language

And think of `mrgc-platform-iac` as:

> the repo where the platform’s cloud and infrastructure blueprints live, separately from app code

That separation is the clean professional move.

---

## Final Takeaway

Terraform is not “just another code file.”

It is the infrastructure contract of the platform.

In this project, it provides the bridge between:

- GitHub source
- Azure DevOps pipeline
- Azure infrastructure
- AKS runtime
- future environment promotion
- future deployment proof and screenshots

That is why it deserves its own repo and its own explanation.
