#!/bin/bash
export hse=$(pwd)
#newtab='tell application "System Events" to keystroke "t" using command down'
echo $hse
#setjdk 11

export NOTIFY_API_KEY="${NOTIFY_API_KEY:-test-key}"
export GOOGLE_ANALYTICS_TRACKING_ID="test-key"
echo 'Notify key being used is: ' $NOTIFY_API_KEY

hash ttab 2>/dev/null || { brew install https://raw.githubusercontent.com/mklement0/ttab/master/ttab.rb; exit 1; }

ttab -t 'applicant-web-ui' -s Grass 'cd htbhf-applicant-web-ui; git status; npm start;'
ttab -t 'session applicant-web-ui' -s Grass 'cd htbhf-applicant-web-ui; git status; npm run test:session-details;'
ttab -t 'claimant-service' -s Grass 'cd htbhf-claimant-service; git status; sleep 5; ./gradlew bootRun;'
ttab -t 'eligibility-service' -s Grass 'cd htbhf-eligibility-service; git status; ./gradlew bootRun;'
ttab -t 'dwp-api' -s Grass 'cd htbhf-dwp-api; git status; ./gradlew bootRun;'
ttab -t 'hmrc-api' -s Grass 'cd htbhf-hmrc-api; git status; ./gradlew bootRun;'
ttab -t 'card-services-api' -s Grass 'cd htbhf-card-services-api; git status; ./gradlew bootRun;'
ttab -t 'smart-stub' -s Grass 'cd htbhf-smart-stub; git status; ./gradlew bootRun;'
ttab -t 'os-places-stub' -s Grass 'cd htbhf-os-places-stub; git status; ./gradlew bootRun;'