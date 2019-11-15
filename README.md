# easyTravel-Docker

![easyTravel Logo](https://github.com/dynatrace-innovationlab/easyTravel-Builder/blob/images/easyTravel-logo.png)

This project builds and deploys the [Dynatrace easyTravel](https://community.dynatrace.com/community/display/DL/Demo+Applications+-+easyTravel) demo application in [Docker](https://www.docker.com/). All components are readily available on the [Docker Hub](https://hub.docker.com/u/dynatrace/).

## Application Components

| Component | Description
|:----------|:-----------
| mongodb   | A pre-populated travel database (MongoDB).
| backend   | The easyTravel Business Backend (Java).
| frontend  | The easyTravel Customer Frontend (Java).
| nginx     | A reverse-proxy for the easyTravel Customer Frontend (NGINX).
| loadgen   | A synthetic UEM load generator (Java).

## Run easyTravel in Docker

You can run easyTravel by using [Docker Compose](https://docs.docker.com/compose/) with the provided `docker-compose.yml` file like so:

```
docker-compose up
```

## Configure easyTravel in Docker

Aligning with principles of [12factor apps](http://12factor.net/config), one of them which requires strict separation of configuration from code, easyTravel can be configured at startup time via the following environment variables:

| Component | Environment Variable  | Defaults                       | Description
|:----------|:----------------------|:-------------------------------|:-----------
| backend   | ET_DATABASE_LOCATION  | easytravel-mongodb:27017       | The location of the database the easyTravel Business Backend shall connect to.
| frontend  | ET_BACKEND_URL        | http://easytravel-backend:8080 | The URL to easyTravel's Business Backend.
| nginx     | ET_FRONTEND_LOCATION  | easytravel-frontend:8080       | The location of the Customer Frontend the easyTravel WWW server shall serve via port 80.
| nginx     | ET_BACKEND_LOCATION   | easytravel-backend:8080        | The location of the Business Backend the easyTravel WWW server shall serve via port 8080.
| loadgen   | ET_WWW_URL            | http://easytravel-www:80       | The URL to easytravel's Customer Frontend.
| loadgen   | ET_BACKEND_URL        | http://easytravel-www:8080     | The URL to easyTravel's Business Backend (optional). If provided, the problem patterns provided in `ET_PROBLEMS` will be applied consecutively for a duration of 10 minutes each.
| loadgen   | ET_PROBLEMS           | BadCacheSynchronization,<br/>CPULoad,<br/>DatabaseCleanup,<br/>DatabaseSlowdown,<br/>FetchSizeTooSmall,<br/>JourneySearchError404,<br/>JourneySearchError500,<br/>LoginProblems,<br/>MobileErrors,<br/>TravellersOptionBox | A list of supported problem patterns, see below on how to activate.
| loadgen   | ET_PROBLEMS_DELAY     | 0                              | A delay in seconds. When used with Dynatrace, it is suggested to use a value of 7500 (slightly more than 2 hours) so that Dynatrace can learn from an error-free behavior first.
| loadgen<br/>backend<br/>frontend | ET_APM_SERVER_DEFAULT | APM | The type of used server. Can be "APM" for Dynatrace and "Classic" for AppMon
| loadgen   | ET_VISIT_NUMBER       | 5                              | The number of visits generated per minute

## Enable easyTravel Problem Patterns

The following problem patterns are supported and triggered through the *loadgen* component, as described above:

| Pattern                 | Description
|:------------------------|:------------
| BadCacheSynchronization | Activating this plugin causes synchronization problems in the customer frontend and uses a lot of CPU by doing an inefficient cache lookup. Activating this plugin should show a class 'CacheLookup' as doing lots of synchronization.
| CPULoad                 | Causes high CPU usage in the business backend process to provoke an unhealthy host health state. The additional CPU time is triggered in 8 separate threads independent of any searching/booking activity.
| DatabaseCleanup         | Cleans out items where we continuously accumulate data in the Database, e.g. Booking and LoginHistory and keeps the last 5000 to avoid filling up the database over time. This is done every 5 minutes at the point where a Journey is searched. Usually this plugin is enabled by default, if you disable it, the database will fill up over time, especially if traffic is generated automatically.
| DatabaseSlowdown        | Plugin which causes queries on locations to take longer.
| FetchSizeTooSmall       | This plugin sets the fetchsize of the Hibernate persistence layer to 1 when executing database queries. This will cause inefficient select statements to show up on databases where otherwise Hibernate is optimizing fetches into bulks.
| JourneySearchError404   | Causes an HTTP 404 error code by returning an image name that does not exist when searching for journeys in the customer frontend web application.
| JourneySearchError500   | Throws an HTTP 500 server error if the journey search parameters are invalid, e.g. toDate is before fromDate
| LargeMemoryLeak         | Causes a large memory leak in the business backend when locations are queried for auto-completion in the search text box in the customer frontend. Note: This will quickly lead to a non-functional Java backend application because of out-of-memory errors.
| LoginProblems           | Simulates an execption when a login is performed in the customer frontend application.
| MobileErrors            | Journey searches and bookings from mobile devices create errors. (no errors created for Tablets)
| TravellersOptionBox     | Causes an 'ArrayIndexOutOfBoundsException' wrapped in an 'InvalidTravellerCostItemException' if in the review-step of the booking flow in the customer frontend, the last option '2 adults+2 kids' is selected in the combo-box for 'travellers'.

## Monitor easyTravel with Dynatrace AppMon

Please refer to the [Dynatrace-Docker](https://github.com/dynatrace/Dynatrace-Docker) project on how to quickly bring up an entire Dockerized Dynatrace environment. Then, use [Docker Compose](https://docs.docker.com/compose/) with the provided `docker-compose-withDtAppMon.yml` file to have the application monitored by [Dynatrace AppMon](http://www.dynatrace.com/en/application-monitoring/):

```
docker-compose -f docker-compose-withDtAppMon.yml up
```

## Problems? Questions? Suggestions?

This offering is [Dynatrace Community Supported](https://community.dynatrace.com/community/display/DL/Support+Levels#SupportLevels-Communitysupported/NotSupportedbyDynatrace(providedbyacommunitymember)). Feel free to share any problems, questions and suggestions with your peers on the Dynatrace Community's [Application Monitoring & UEM Forum](https://answers.dynatrace.com/spaces/146/index.html).

## License

Licensed under the MIT License. See the [LICENSE](https://github.com/dynatrace-innovationlab/easyTravel-Docker/blob/master/LICENSE) file for details.
