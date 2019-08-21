# Runbook for Apply for Healthy Start

## Continuous Integration and Continuous Delivery
All projects are built by [travis-ci](https://travis-ci.com/DepartmentOfHealth-htbhf/) - this is governed by the `.travis.yml` file in each project.
Generally each project runs a `ci_deploy.sh` script after a successful build to deploy the latest build to development.
This downloads and runs the code in [htbhf-deployment-scripts](https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts) to perform a blue-green deployment and run smoke tests.
Assuming these pass `.travis.yml` will create a new release and invoke an `after-success` step to trigger the [CD pipeline](https://github.com/DepartmentOfHealth-htbhf/htbhf-continous-delivery)
to deploy to staging (including running integration, compatibility and performance tests) and production.


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

#### Configuring log filters
Our logit filter configuration is available at: [https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/blob/master/examples/logstash.conf](https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/blob/master/examples/logstash.conf),
and can be updated using the logit.io dashboard: [https://logit.io/a/53b8dcc2-acae-42c6-b2a9-93a0e15e0885](https://logit.io/a/53b8dcc2-acae-42c6-b2a9-93a0e15e0885)
(this is not something that needs to be updated until/unless the format of log messages changes).


## Metrics
We have set up metrics exporting from the PaaS (following instructions here: [docs.cloud.service.gov.uk/monitoring_apps.html](https://docs.cloud.service.gov.uk/monitoring_apps.html#monitoring-apps))
Please see the [prometheus repository](https://github.com/DepartmentOfHealth-htbhf/prometheus) for details on the Prometheus app that has been deployed to the PaaS to export metrics.

These metrics are viewable from a [Grafana dashboard](https://helptobuyhealthyfoods.grafana.net/dashboards) (login required).
This includes only the default metrics as provided by the PaaS - there are no application-specific or jvm metrics.

#### Application-specific metrics

Some spring boot apps (such as the claimant service) do expose additional metrics.
It is possible to view these metrics from your local machine by running the following command (this example is to view metrics for instance 0 of the claimant service in the staging space):
```cf ssh -N -T -L 8080:localhost:8080 htbhf-claimant-service-staging -i 0```
Then open this url in your local browser: http://localhost:8080/actuator/prometheus (see http://localhost:8080/actuator/ for a list of all actuator endpoints).
You can get metrics for another instance by changing the `-i` parameter :
```cf ssh -N -T -L 8080:localhost:8080 htbhf-claimant-service-staging -i 1```

You can also run a local instance of Prometheus for easier interpretation of the metrics: https://prometheus.io/docs/prometheus/latest/getting_started/


It is also possible to monitor individual applications by installing the [cf log-cache plugin](https://github.com/cloudfoundry/log-cache-cli#installing-plugin).

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

## Setting environment variables

Environment variables are controlled via user provided services, primarily the `variable-service` - this single service controls the following environment variables for all apps in the space:

* GA_TRACKING_ID
* DWP_API_URI
* HMRC_API_URI
* CARD_SERVICES_API_URI
* UI_LOG_LEVEL
* And (optionally) claimant-root-loglevel & claimant-app-loglevel

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

Due to this limitation with user provided services, subsequent configuration values have been placed in their own service.
For instance the `notify-variable-service` has a single variable 'NOTIFY_API_KEY'.

## Configuring the number & size of instances
Instance sizes are controlled by a single variable - the amount of memory assigned to the instance. This also governs the number of CPU cycles available to the instance.
This is generally configured in the manifest.yml file in each project, but can be overridden in staging and production - along with the number of instances in those environments.
These can be controlled by editing [instance-sizes-staging.properties](https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/tree/master/instance-sizes-staging.properties)
and [instance-sizes-production.properties](https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/tree/master/instance-sizes-production.properties) respectively.

## Deploying a specific version of an app
To manually deploy a microservice (bypassing tests in staging), see [deploying-applications-to-staging-and-production](https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/tree/master/management-scripts#deploying-applications-to-staging-and-production)

## Shuttering the site for maintenance ('Service Unavailable')
To display a 'Service Unavailable' page, see [displaying-a-service-unavailable-page](https://github.com/DepartmentOfHealth-htbhf/htbhf-deployment-scripts/tree/master/management-scripts#displaying-a-service-unavailable-page)

## Querying the database for Claimants
See [accessing-paas-databases](https://github.com/DepartmentOfHealth-htbhf/htbhf-claimant-service/tree/master/db#accessing-paas-databases)
and [querying-the-db-for-claimants](https://github.com/DepartmentOfHealth-htbhf/htbhf-claimant-service/tree/master/db#querying-the-db-for-claimants)

## Restoring the database after a catastrophic failure
See https://helptobuyhealthyfood.atlassian.net/wiki/spaces/PRBE/pages/44105784/Restoring+the+database+from+a+backup

## Database auditing
Auditing of claims is implemented using the [Javers](https://javers.org/) library. See [database auditing](https://github.com/DepartmentOfHealth-htbhf/htbhf-claimant-service/tree/master/db#claim-auditing) for more information.
