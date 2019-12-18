# Local Development
When an app runs in CloudFoundry it will listen on port 8080. 
However to enable us to run all applications locally we need to configure different ports.
CloudFoundry will automatically map the port to 8080 so no additional config is required.

These are the applications you need to check out and run locally for the full end-to-end service.
All applications can be found here: https://github.com/DepartmentOfHealth-htbhf/

Applications may require additional services - both Postgres and Redis must be running locally.

| Service                                                     | Port | Command(s)                                                                                                                                                    |
| :--------------------------                                 | :--- | :----------                                                                                                                                                   |
| htbhf-applicant-web-ui                                      | 8080 | `export NOTIFY_API_KEY={the notify api key}`<br>`export GOOGLE_ANALYTICS_TRACKING_ID=test-key`<br>(or better, populate these in a `.env` file)<br>`npm start` |
| session details app<br>(in the htbhf-applicant-web-ui repo) | 8081 | `npm run test:session-details`                                                                                                                                |
| htbhf-claimant-service                                      | 8090 | `export NOTIFY_API_KEY={the notify api key}`<br>`export GOOGLE_ANALYTICS_TRACKING_ID=test-key`<br>`./gradlew bootRun`                                         |
| htbhf-eligibility-service                                   | 8100 | `./gradlew bootRun`                                              -                                                                                             |
| htbhf-dwp-api                                               | 8110 | `./gradlew bootRun`                                                                                                                                           |
| htbhf-smart-stub                                            | 8120 | `./gradlew bootRun`                                                                                                                                           |
| htbhf-hmrc-api                                              | 8130 | `./gradlew bootRun`                                                                                                                                           |
| htbhf-card-services-api                                     | 8140 | `./gradlew bootRun`                                                                                                                                           |
| htbhf-os-places-stub                                        | 8150 | `./gradlew bootRun`                                                                                                                                           |


See also [run_all_linux.sh](run_all_linux.sh) for an example script to start all the applications on a linux machine.