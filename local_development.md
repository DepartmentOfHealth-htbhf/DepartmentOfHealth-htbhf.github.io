# Local Development
When an app runs in CloudFoundry it will listen on port 8080. 
However to enable us to run all applications locally we need to configure different ports.
CloudFoundry will automatically map the port to 8080 so no additional config is required.

These are the applications you need to check out and run locally for the full end-to-end service.

| Service                     | Port | Command(s)                                                                                                      |
| :-------------------------- | :--- | :----------                                                                                                     |
| htbhf-applicant-web-ui      | 8080 | export NOTIFY_API_KEY={the notify api key}<br>export GOOGLE-ANALYTICS_TRACKING-ID=test-key<br>npm start         |
| session details app         | 8081 | npm run test:session-details                                                                                    |
| htbhf-claimant-service      | 8090 | export NOTIFY_API_KEY={the notify api key}<br>export GOOGLE-ANALYTICS_TRACKING-ID=test-key<br>./gradlew bootRun |
| htbhf-eligibility-service   | 8100 | ./gradlew bootRun                                                                                               |
| htbhf-dwp-api               | 8110 | ./gradlew bootRun                                                                                               |
| htbhf-smart-stub            | 8120 | ./gradlew bootRun                                                                                               |
| htbhf-hmrc-api              | 8130 | ./gradlew bootRun                                                                                               |
| htbhf-card-services-api     | 8140 | ./gradlew bootRun                                                                                               |
| htbhf-os-places-stub        | 8150 | ./gradlew bootRun                                                                                               |
