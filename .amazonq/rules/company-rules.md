# EuroFinBank AWS Infrastructure Compliance Rules

**Description:**  
This document defines EuroFinBank’s mandatory rules for deploying and operating AWS infrastructure in accordance with EU Financial Services regulations (e.g. PSD2, GDPR, DORA). Rules may override or extend AWS Well-Architected best practices. An external AI tool can parse headings (`## Pillar: …`) and priority tags (`[P1]`, `[P2]`, `[P3]`) to classify and enforce requirements.

## Pillars & Priorities
- **P1** = High Priority (Regulatory Mandates)  
- **P2** = Medium Priority (Required Controls)  
- **P3** = Low Priority (Best‐Practice Guidance)

---

## Pillar: Governance & Compliance  
- **[P1]** Maintain a centralized AWS Landing Zone with guardrails codified via AWS Control Tower and Service Catalog.  
- **[P1]** Enforce tagging policies (cost center, data sensitivity, regulatory domain) via AWS Organizations SCPs.  
- **[P1]** Record and version all infrastructure as code (IaC) in a secure Git repository with restricted merge approvals.

- **[P2]** Enable AWS Config rules for continuous compliance checks against internal policies and EU regulations.  
- **[P2]** Automate drift detection and remediation for critical accounts and resources.  
- **[P2]** Conduct quarterly infrastructure policy reviews and updates.

- **[P3]** Publish an internal compliance dashboard (AWS CloudWatch + Athena) summarizing rule violations.  
- **[P3]** Maintain an IaC module library approved by the security and compliance teams.

---

## Pillar: Security & Data Protection  
- **[P1]** Enforce least-privilege IAM roles with permission boundaries and enable AWS IAM Access Analyzer.  
- **[P1]** Require MFA for all privileged users and enforce hardware-based MFA for administrators.  
- **[P1]** Enable AWS CloudTrail in all regions, send logs to a centralized, immutable S3 bucket with encryption and Object Lock.

- **[P2]** Use AWS KMS with customer-managed keys (CMKs) for encrypting EBS, RDS, S3, and Secrets Manager secrets.  
- **[P2]** Automate vulnerability scanning (Inspector) and quarterly penetration testing for all VPCs.  
- **[P2]** Implement VPC Flow Logs and DNS query logs routed to a SIEM for anomaly detection.

- **[P3]** Rotate CMKs and IAM access keys on a 90-day cycle.  
- **[P3]** Provide annual secure-coding and cloud-security training to developers.

---

## Pillar: Network & Infrastructure Deployment  
- **[P1]** Architect all deployments using multi-Account strategy: separate prod, non-prod, audit, and sandbox.  
- **[P1]** Enforce private subnets for all workloads; restrict Internet egress via NAT gateways and WAF.  
- **[P1]** Deploy critical services across ≥2 AZs with AWS Global Accelerator for cross-region traffic routing where required by DORA.

- **[P2]** Use Infrastructure as Code (Terraform or CloudFormation) with automated plan/apply pipelines and approval gates.  
- **[P2]** Implement AWS Transit Gateway or PrivateLink for secure connectivity to third-party services (e.g., PSD2 APIs).  
- **[P2]** Define and enforce network ACLs and security group rules as code, disallowing wide “0.0.0.0/0” openings.

- **[P3]** Use AWS Service Quotas and Well-Architected Monitoring scripts to alert on capacity limits.  
- **[P3]** Maintain a catalog of approved AMIs hardened by CIS Benchmarks.

---

## Pillar: Data Management & Privacy  
- **[P1]** Classify and tag data by sensitivity; enforce IAM policies and bucket policies to restrict access.  
- **[P1]** Encrypt all data at rest and in transit using TLS 1.2+ and KMS CMKs; use AWS Certificate Manager for TLS certs.  
- **[P1]** Implement automated Data Lifecycle policies in S3 (transition to Glacier Deep Archive) aligned to retention rules (min. 5 years).

- **[P2]** Enable S3 Object Lock in Governance mode for regulatory immutability where required (e.g., transaction logs).  
- **[P2]** Automate discovery of PII via Amazon Macie and remediate policy violations within 24 hours.  
- **[P2]** Log and audit all data access events; retain logs per GDPR & MiFID II (min. 5 years).

- **[P3]** Periodically review data classification and lifecycle policies.  
- **[P3]** Provide self-service data export and deletion workflows to satisfy data subject requests.

---

## Pillar: Resilience & Operational Excellence  
- **[P1]** Define and test DR runbooks annually; target RTO ≤4 hours and RPO ≤1 hour for critical systems.  
- **[P1]** Implement automated failover for RDS (Multi-AZ) and ECS/EKS services with health-check probes.  
- **[P1]** Use AWS Backup to centrally manage backups for RDS, EFS, DynamoDB, and EC2 with cross-region copy.

- **[P2]** Schedule “game days” to simulate region failures and validate recovery playbooks.  
- **[P2]** Instrument key SLO/SLA metrics (latency, error rate, throughput) in Amazon CloudWatch dashboards.  
- **[P2]** Automate remediation for common faults using AWS Systems Manager Automation runbooks.

- **[P3]** Maintain runbooks and post-incident review documents in a centralized knowledge base.  
- **[P3]** Continuously refine runbooks based on lessons learned.

---

## Pillar: Performance & Cost Management  
- **[P1]** Right-size compute resources via AWS Compute Optimizer; enforce scheduled scaling policies.  
- **[P1]** Use Savings Plans and Reserved Instances for baseline workloads; spot instances for flexible jobs.  
- **[P1]** Tag all resources for cost allocation; enforce tag compliance via AWS Budgets and Cost Anomaly Detection.

- **[P2]** Monitor performance metrics (CPU, memory, I/O) and alert on deviations from baselines.  
- **[P2]** Adopt serverless (Lambda, Fargate) where latency and cost profiles fit, per regulatory latency budgets.  
- **[P2]** Audit underutilized or idle resources monthly and automatically schedule shutdowns.

- **[P3]** Publish quarterly cost and performance reports to engineering and finance teams.  
- **[P3]** Explore emerging AWS instance types and managed services for future efficiency gains.

---

## Pillar: Sustainability  
- **[P1]** Set cloud carbon footprint targets and integrate with AWS Customer Carbon Footprint Tool.  
- **[P1]** Prefer AWS Graviton processors and serverless to maximize performance per watt.  
- **[P1]** Include sustainability metrics in architectural reviews and approvals.

- **[P2]** Schedule non-critical batch workloads during off-peak grid hours in regions with higher renewable mix.  
- **[P2]** Automate shutdown of dev/test environments outside business hours.

- **[P3]** Publish an internal “Green Cloud” scorecard each quarter.  
- **[P3]** Incentivize teams to propose sustainability improvements during design sprints.
