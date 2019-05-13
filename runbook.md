# Runbook for Help To Buy Healthy Foods


## Logs
We use Logit to make application logs accessible, as recommended here: https://docs.publishing.service.gov.uk/manual/logit.html

#### Viewing the logs
Logs are visible on the Logit.io Kibana dashboard: https://kibana.logit.io/app/kibana
(Note that you must have been granted access).

It is possible to use the request id or session id to track an individual web request (or the whole session) all the way through the stack.
Both request and session ids are included in each http response (the X-Vcap-Request-Id header and htbhf.sid cookie, respectively).

#### Setting the log level
The simplest way to set log levels is to update them in the `application.yml` file for the relevant application and redeploy.
However it is possible to update them using environment variables - though the service must be restarted for this to take effect.

#### Setting environment variables
Environment variables are controlled via the 'variable-service' user provided service - this single service controls environment variables for all apps in the space. 
Use `cf update-user-provided-service` to update these values - new values will take effect on the next deployment.

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

#### Configuring log filters
Our logit filter configuration is available at: https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/blob/master/examples/logstash.conf,
and can be updated using the logit.io dashboard: https://logit.io/a/53b8dcc2-acae-42c6-b2a9-93a0e15e0885
(this is not something that needs to be updated until/unless the format of log messages changes).


## Metrics
We have not yet set up metrics exporting from the PaaS - for instructions on doing so see: https://docs.cloud.service.gov.uk/monitoring_apps.html#monitoring-apps

There is still some monitoring that is possible by installing the [cf log-cache plugin](https://github.com/cloudfoundry/log-cache-cli#installing-plugin).

Having installed the plugin, use the following command to obtain metrics for an individual app (including CPU and memory usage):
```bash
$ cf tail --help
NAME:
   tail - Output logs for a source-id/app

USAGE:
   tail [options] <source-id/app>

ENVIRONMENT VARIABLES:
   LOG_CACHE_ADDR       Overrides the default location of log-cache.
   LOG_CACHE_SKIP_AUTH  Set to 'true' to disable CF authentication.

OPTIONS:
   --start-time               Start of query range in UNIX nanoseconds.
   --end-time                 End of query range in UNIX nanoseconds.
   --follow, -f               Output appended to stdout as logs are egressed.
   --lines, -n                Number of envelopes to return. Default is 10.
   --envelope-class, -c       Envelope class filter. Available filters: 'logs', 'metrics', and 'any'.
   --envelope-type, -t        Envelope type filter. Available filters: 'log', 'counter', 'gauge', 'timer', 'event', and 'any'.
   --json                     Output envelopes in JSON format.
   --name-filter              Filters metrics by name.
   --new-line                 Character used for new line substition, must be single unicode character. Default is '\n'.
```

E.g. to obtain metrics for an app and write them to `metrics.txt` (it will keep running until you kill the command):
```bash
$ cf tail my-app-name -c metrics -f > metrics.txt
```
The output will look something like the following:
```bash
Retrieving logs for app htbhf-claimant-service-staging in org department-of-health-and-social-care / space staging as msmith@equalexperts.com...

   2019-03-29T10:01:57.11+0000 [htbhf-claimant-service-staging/1] GAUGE cpu:0.093310 percentage disk:175607808.000000 bytes disk_quota:1073741824.000000 bytes memory:292302848.000000 bytes memory_quota:1073741824.000000 bytes
   2019-03-29T10:01:57.11+0000 [htbhf-claimant-service-staging/1] GAUGE absolute_entitlement:0.000000 nanoseconds absolute_usage:69119660018.000000 nanoseconds container_age:20990298995898.000000 nanoseconds
   2019-03-29T10:02:10.65+0000 [htbhf-claimant-service-staging/0] GAUGE cpu:0.105926 percentage disk:175607808.000000 bytes disk_quota:1073741824.000000 bytes memory:280776704.000000 bytes memory_quota:107374182
```

## Querying the database for Claimants
See [accessing-paas-databases](https://github.com/DepartmentOfHealth-htbhf/htbhf-claimant-service/tree/master/db#accessing-paas-databases)
and [querying-the-db-for-claimants](https://github.com/DepartmentOfHealth-htbhf/htbhf-claimant-service/tree/master/db#querying-the-db-for-claimants)

## Restoring the database after a catastrophic failure
See https://helptobuyhealthyfood.atlassian.net/wiki/spaces/PRBE/pages/44105784/Restoring+the+database+from+a+backup

## Shuttering the site for maintenance ('Service Unavailable')
To display a 'Service Unavailable' page, see [displaying-a-service-unavailable-page](https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/tree/master/management-scripts#displaying-a-service-unavailable-page)

## Deploying a specific version of an app
To manually deploy a microservice (bypassing tests in staging), see [deploying-applications-to-staging-and-production](https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/tree/master/management-scripts#deploying-applications-to-staging-and-production)