# Runbook for Help To Buy Healthy Foods


## Logs
We use Logit to make application logs accessible, as recommended here: https://docs.publishing.service.gov.uk/manual/logit.html

#### Viewing the logs
Logs are visible on the Logit.io Kibana dashboard: https://kibana.logit.io/app/kibana
(Note that you must have been granted access).

It is possible to use the request id or session id to track an individual web request (or the whole session) all the way through the stack.
Both request and session ids are included in each http response (the X-Vcap-Request-Id header and htbhf.sid cookie, respectively).

#### Configuring log filters
Our logit filter configuration is available at: https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/blob/master/examples/logstash.conf,
and can be updated using the logit.io dashboard: https://logit.io/a/53b8dcc2-acae-42c6-b2a9-93a0e15e0885
(this is not something that needs to be updated until/unless the format of log messages changes).

#### Setting the log level
Log levels for both the applicant-web-ui and claimant-service can be set using environment variables, 
controlled via the 'variable-service' user provided service. Use `cf update-user-provided-service` to update these values - new values will take effect on the next deployment.

Note that any update to a user provided service will replace that service, so you must specify all variables - you can't update just one of them.
Use `cf env app-name` to view the existing environment variables (where app-name is, for example, htbhf-claimant-service) - you should see output similar to the following:
```
System-Provided:
{
 "VCAP_SERVICES": {
...
  "user-provided": [
   {
    "binding_name": null,
    "credentials": {
     "GA_TRACKING_ID": "UA-133839203-1",
     "UI_LOG_LEVEL": "debug"
    },
    "instance_name": "variable-service",
    "label": "user-provided",
    "name": "variable-service",
    ...
   },
...
```
You must include each of the values in 'credentials', and change/add the value you wish to set, e.g.:
```
cf update-user-provided-service variable-service -p '{"GA_TRACKING_ID": "UA-133839203-1", "UI_LOG_LEVEL": "debug", "claimant-app-loglevel": "debug"}'
```

## Querying the database for Claimants
See [accessing-paas-databases](https://github.com/DepartmentOfHealth-htbhf/htbhf-claimant-service/tree/master/db#accessing-paas-databases)
and [querying-the-db-for-claimants](https://github.com/DepartmentOfHealth-htbhf/htbhf-claimant-service/tree/master/db#querying-the-db-for-claimants)

## Restoring the database after a catastrophic failure
See https://helptobuyhealthyfood.atlassian.net/wiki/spaces/PRBE/pages/44105784/Restoring+the+database+from+a+backup