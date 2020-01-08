#!/bin/bash
export hse=$(pwd)
#newtab='tell application "System Events" to keystroke "t" using command down'
echo $hse

export NOTIFY_API_KEY="${NOTIFY_API_KEY:-test-key}"
export GOOGLE_ANALYTICS_TRACKING_ID="test-key"
echo 'Notify key being used is: ' $NOTIFY_API_KEY

#osascript -e 'tell application "Terminal"' -e 'activate' -e 'to do script cd $hse/htbhf-applicant-web-ui; git status; npm start; pause.sh' -e 'end tell'
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-applicant-web-ui; git status; npm start; pause.sh\""
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-applicant-web-ui; git status; npm run test:session-details; pause.sh\""
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-claimant-service; git status; sleep 5; ./gradlew bootRun; pause.sh\""
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-eligibility-service; git status; ./gradlew bootRun; pause.sh\""
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-dwp-api; git status; ./gradlew bootRun; pause.sh\""
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-hmrc-api; git status; ./gradlew bootRun; pause.sh\""
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-card-services-api; git status; ./gradlew bootRun; pause.sh\""
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-smart-stub; git status; ./gradlew bootRun; pause.sh\""
osascript -e "tell application \"Terminal\" to do script \"cd $hse/htbhf-os-places-stub; git status; ./gradlew bootRun; pause.sh\""

