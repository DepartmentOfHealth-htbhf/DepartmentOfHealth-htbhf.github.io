# PORTS
When an app runs in CloudFoundry it will listen on port 8080. 
However to enable us to run all applications locally we need to configure different ports.
CloudFoundry will automatically map the port to 8080 so no additional config is required.

| Service                   | Port |
|:--------------------------|:-----|
| htbhf-applicant-web-ui    | 8080 |
| htbhf-claimant-service    | 8090 |
| htbhf-eligibility-service | 8100 |
| htbhf-dwp-api             | 8110 |
| htbhf-smart-stub          | 8120 |
| htbhf-hmrc-api            | 8130 |
| htbhf-card-services-api   | 8140 |
