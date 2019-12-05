#!/bin/bash
cd ~/NHS # replace this with the parent directory on your machine

export NOTIFY_API_KEY="put the real key here"
export GOOGLE_ANALYTICS_TRACKING_ID="test-key"

gnome-terminal --tab -- bash -c "echo -ne '\033]0;(web-ui)\007'; cd htbhf-applicant-web-ui; git status; npm start;"
gnome-terminal --tab -- bash -c "echo -ne '\033]0;(session)\007'; cd htbhf-applicant-web-ui; git status; npm run test:session-details;"
gnome-terminal --tab -- bash -c "echo -ne '\033]0;(claimant)\007'; cd htbhf-claimant-service; git status; sleep 5; ./gradlew bootRun;"
gnome-terminal --tab -- bash -c "echo -ne '\033]0;(eligibility)\007'; cd htbhf-eligibility-service; git status; ./gradlew bootRun;"
gnome-terminal --tab -- bash -c "echo -ne '\033]0;(dwp)\007'; cd htbhf-dwp-api; git status; ./gradlew bootRun;"
gnome-terminal --tab -- bash -c "echo -ne '\033]0;(hmrc)\007'; cd htbhf-hmrc-api; git status; ./gradlew bootRun;"
gnome-terminal --tab -- bash -c "echo -ne '\033]0;(cards)\007'; cd htbhf-card-services-api; git status; ./gradlew bootRun;"
gnome-terminal --tab -- bash -c "echo -ne '\033]0;(smart-stub)\007'; cd htbhf-smart-stub; git status; ./gradlew bootRun;"
gnome-terminal --tab -- bash -c "echo -ne '\033]0;(os-places-stub)\007'; cd htbhf-os-places-stub; git status; ./gradlew bootRun;"

