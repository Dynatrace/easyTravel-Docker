# easyTravel-Docker

![easyTravel Logo](https://github.com/dynatrace-innovationlab/easyTravel-Builder/blob/images/easyTravel-logo.png)

This project builds and deploys the [Dynatrace easyTravel](https://community.dynatrace.com/community/display/DL/Demo+Applications+-+easyTravel) demo application in [Docker](https://www.docker.com/). All components are readily available on the [Docker Hub](https://hub.docker.com/u/dynatrace/).

## Application Components

| Component               | Description
|:------------------------|:-----------
| mongodb                 | A pre-populated travel database (MongoDB).
| backend                 | The easyTravel Business Backend (Java).
| frontend                | The easyTravel Customer Frontend (Java).
| nginx                   | A reverse-proxy for the easyTravel Customer Frontend (NGINX).
| angularfrontend         | The easyTravel Customer Frontend (Java,Angular).
| headleassloadgen        | Load generator using headless Chrome (Java).
| pluginservice           | Optional component that keeps state of plugins. Used in case of multiple backend components (Java).
| mongodb-content-creator | Allows to create easyTravel database content in empty MongoDB database.
| loadgen (deprecated)    | A synthetic load generator (Java).

## Run easyTravel in Docker

You can run easyTravel by using [Docker Compose](https://docs.docker.com/compose/) with the provided `docker-compose.yml` file like so:

```
docker-compose up
```
NOTE: if you want to decrease memory usage, you can remove loadgen component from `docker-compose.yml`
## Configure easyTravel in Docker

Aligning with principles of [12factor apps](http://12factor.net/config), one of them which requires strict separation of configuration from code, easyTravel can be configured at startup time via the following environment variables:

| Component                        | Environment Variable  | Defaults                                                                                                                                                                                                                   | Description
|:---------------------------------|:----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------
| backend                          | ET_DATABASE_LOCATION  | easytravel-mongodb:27017      | The location of the database the easyTravel Business Backend shall connect to.
| backend                          | ET_MONGO_AUTH_DB      | admin                         | Name of the MongoDB authentication database
| backend                          | ET_DATABASE_USER      | etAdmin                       | Name of the MongoDB user
| backend                          | ET_DATABASE_PASSWORD  | adminadmin                    | MongoDB user password
| frontend                         | ET_BACKEND_URL        | http://easytravel-backend:8080| The URL to easyTravel's Business Backend.
| nginx                            | ET_FRONTEND_LOCATION  | easytravel-frontend:8080      | The location of the Customer Frontend the easyTravel WWW server shall serve via port 80.
| nginx                            | ET_BACKEND_LOCATION   | easytravel-backend:8080       | The location of the Business Backend the easyTravel WWW server shall serve via port 8080.
| backend<br/>frontend		   | ET_APM_SERVER_DEFAULT | APM                           | The type of used server. Can be "APM" for Dynatrace and "Classic" for AppMon
| angularfrontend                  | ET_BACKEND_URL        | http://easytravel-backend:8080| The URL to easyTravel's Business Backend
| headlessloadgen                  | ET_FRONTEND_URL       | http://easytravel-www:9079    | The URL to easyTravel's Frontend
| headlessloadgen                  | ET_VISIT_NUMBER       | 1                             | The number of visits generated per minute
| headlessloadgen                  | MAX_CHROME_DRIVERS    | 1                             | Maximum number of chrome drivers
| headlessloadgen                  | REUSE_CHROME_DRIVER_FREQUENCY | 1                     | How many times we should use one chrome instance for generating visits. Increasing this improves performance, however causes some strange behaviours with generated user sessions.
| headlessloadgen                  | SCENARIO_NAME         | Headless Scenario             | Name of the scenario
| headlessloadgen                  | ET_PROBLEMS           | BadCacheSynchronization,<br/>CPULoad,<br/>DatabaseCleanup,<br/>FetchSizeTooSmall,<br/>JourneySearchError404,<br/>JourneySearchError500,<br/>LoginProblems,<br/>MobileErrors,<br/>TravellersOptionBox | A list of supported problem patterns, see below on how to activate.
| headlessloadgen                  | ET_PROBLEMS_DELAY     | 0                              | A delay in seconds. When used with Dynatrace, it is suggested to use a value of 7500 (slightly more than 2 hours) so that Dynatrace can learn from an error-free behavior first.
| loadgen   | ET_WWW_URL            | http://easytravel-www:80       | The URL to easytravel's Customer Frontend.
| loadgen   | ET_BACKEND_URL        | http://easytravel-www:8080     | The URL to easyTravel's Business Backend (optional). If provided, the problem patterns provided in `ET_PROBLEMS` will be applied consecutively for a duration of 10 minutes each.
| loadgen   | ET_PROBLEMS           | BadCacheSynchronization,<br/>CPULoad,<br/>DatabaseCleanup,<br/>FetchSizeTooSmall,<br/>JourneySearchError404,<br/>JourneySearchError500,<br/>LoginProblems,<br/>MobileErrors,<br/>TravellersOptionBox | A list of supported problem patterns, see below on how to activate.
| loadgen   | ET_PROBLEMS_DELAY     | 0                              | A delay in seconds. When used with Dynatrace, it is suggested to use a value of 7500 (slightly more than 2 hours) so that Dynatrace can learn from an error-free behavior first.
| loadgen   | ET_VISIT_NUMBER       | 2                              | The number of visits generated per minute



## Enable easyTravel Problem Patterns

The following problem patterns are supported and triggered through the *loadgen* component, as described above:

| Pattern                 | Description
|:------------------------|:------------
| BadCacheSynchronization | Activating this plugin causes synchronization problems in the customer frontend and uses a lot of CPU by doing an inefficient cache lookup. Activating this plugin should show a class 'CacheLookup' as doing lots of synchronization.
| CPULoad                 | Causes high CPU usage in the business backend process to provoke an unhealthy host health state. The additional CPU time is triggered in 8 separate threads independent of any searching/booking activity.
| DatabaseCleanup         | Cleans out items where we continuously accumulate data in the Database, e.g. Booking and LoginHistory and keeps the last 5000 to avoid filling up the database over time. This is done every 5 minutes at the point where a Journey is searched. Usually this plugin is enabled by default, if you disable it, the database will fill up over time, especially if traffic is generated automatically.
| FetchSizeTooSmall       | This plugin sets the fetchsize of the Hibernate persistence layer to 1 when executing database queries. This will cause inefficient select statements to show up on databases where otherwise Hibernate is optimizing fetches into bulks.
| JourneySearchError404   | Causes an HTTP 404 error code by returning an image name that does not exist when searching for journeys in the customer frontend web application.
| JourneySearchError500   | Throws an HTTP 500 server error if the journey search parameters are invalid, e.g. toDate is before fromDate
| LargeMemoryLeak         | Causes a large memory leak in the business backend when locations are queried for auto-completion in the search text box in the customer frontend. Note: This will quickly lead to a non-functional Java backend application because of out-of-memory errors.
| LoginProblems           | Simulates an execption when a login is performed in the customer frontend application.
| MobileErrors            | Journey searches and bookings from mobile devices create errors. (no errors created for Tablets)
| TravellersOptionBox     | Causes an 'ArrayIndexOutOfBoundsException' wrapped in an 'InvalidTravellerCostItemException' if in the review-step of the booking flow in the customer frontend, the last option '2 adults+2 kids' is selected in the combo-box for 'travellers'.

## How to build easyTravel Docker images ?

Use `build.sh` if you want to build easyTravel Docker images yourself.

## How to build easyTravel deployment artefacts ?

### Option A: 'build-et.sh'

The `build-et.sh` script builds easyTravel deployment artefacts into a directory `deploy` inside your current working directory, by default. You can override the default behavior by providing the following *environment variables* to the script:

| Environment Variable  | Defaults                    | Description
|:----------------------|:----------------------------|:-----------
| ET_SRC_URL            | http://etinstallers.demoability.dynatracelabs.com/latest/dynatrace-easytravel-src.zip | A URL to an easyTravel source distribution .zip file.
| ET_DEPLOY_HOME        | ./deploy                    | A directory to contain the easyTravel deployment artefacts.
| ET_BB_DEPLOY_HOME     | ./backend                   | A directory under `${ET_DEPLOY_HOME}` to contain the easyTravel Business Backend deployment artefact (will be located in `${ET_DEPLOY_HOME}/${ET_BB_DEPLOY_HOME}`).
| ET_CF_DEPLOY_HOME     | ./frontend                  | A directory under `${ET_DEPLOY_HOME}` to contain the easyTravel Customer Frontend deployment artefact (will be located in `${ET_DEPLOY_HOME}/${ET_CF_DEPLOY_HOME}`).
| ET_ACF_DEPLOY_HOME    | ./angularfrontend           | A directory under `${ET_DEPLOY_HOME}` to contain the easyTravel Customer Frontend (Angular) deployment artefact (will be located in `${ET_DEPLOY_HOME}/${ET_ACF_DEPLOY_HOME}`).
| ET_LG_DEPLOY_HOME     | ./loadgen                   | A directory under `${ET_DEPLOY_HOME}` to contain the easyTravel UEM load generator deployment artefact (will be located in `${ET_DEPLOY_HOME}/${ET_LG_DEPLOY_HOME}`).
| ET_HLG_DEPLOY_HOME    | ./headlessloadgen           | A directory under `${ET_DEPLOY_HOME}` to contain the easyTravel headless Angular load generator (Java) deployment artefact (will be located in `${ET_DEPLOY_HOME}/${ET_HLG_DEPLOY_HOME}`).
| ET_MG_DEPLOY_HOME     | ./mongodb                   | A directory under `${ET_DEPLOY_HOME}` to contain the easyTravel pre-populated travel database (will be located in `${ET_DEPLOY_HOME}/${ET_MG_DEPLOY_HOME}`).
| ET_MGC_DEPLOY_HOME    | ./mongodb-content-creator   | A directory under `${ET_DEPLOY_HOME}` to contain the easyTravel MongoDB Content Creator deployment artefact (will be located in `${ET_DEPLOY_HOME}/${ET_MGC_DEPLOY_HOME}`).
| ET_PS_DEPLOY_HOME     | ./pluginservice             | A directory under `${ET_DEPLOY_HOME}` to contain the easyTravel Plugin Service deployment artefact (will be located in `${ET_DEPLOY_HOME}/${ET_PS_DEPLOY_HOME}`).

#### Example: create deployment artefacts in `./deploy`:

```
./build-et.sh
```

#### Example: create deployment artefacts in `./deploy` and no sub-folders:

```
export ET_BB_DEPLOY_HOME=. \
export ET_CF_DEPLOY_HOME=. \
export ET_ACF_DEPLOY_HOME=. \
export ET_LG_DEPLOY_HOME=. \
export ET_HLG_DEPLOY_HOME=. \
export ET_MG_DEPLOY_HOME=. \
export ET_MGC_DEPLOY_HOME=. \
export ET_PS_DEPLOY_HOME=. \
./build-et.sh
```

### Option B: 'build-in-docker.sh'

Use `build-in-docker.sh` if you want to build easyTravel deployment artefacts in a build environment that runs in Docker, so you don't have to set up your own. Deployment artefacts can be found in a directory `deploy` inside your current working directory. You can override the default behavior by providing *environment variables* to the script (the same variables as in Option A).

## Problems? Questions? Suggestions?

This offering is [Dynatrace Community Supported](https://community.dynatrace.com/community/display/DL/Support+Levels#SupportLevels-Communitysupported/NotSupportedbyDynatrace(providedbyacommunitymember)). Feel free to share any problems, questions and suggestions with your peers on the Dynatrace Community's [Application Monitoring & UEM Forum](https://answers.dynatrace.com/spaces/146/index.html).

## License

Licensed under the MIT License. See the [LICENSE](https://github.com/dynatrace-innovationlab/easyTravel-Docker/blob/master/LICENSE) file for details.
