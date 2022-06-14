#!/usr/bin/env bash

set -e

curl --location --request POST 'https://fcm.googleapis.com/fcm/send' \
--header 'Content-Type: application/json' \
--header 'Authorization: key=AAAAVOD0t9U:APA91bHz5EV9FZvk82PsPhIFnxm8EsuI7Ll7yK2HXN6pLq47nRGDJN_PcH7ai6I5EycXq_V-xK8w4Rcomtkw_podj37AQ7O9uVR6Uf4SP9QuKRJjwIP92VuANzw4_9JdUavFAImbYyXJ' \
--data-raw '{
    "data":
    {
        "type": "replacement.approved",
        "replacementId": 1,
    },
    "android":
    {
        "priority":"high"
    },
    "to" : "cS4Dnm3-R2e4K9c8r4bvwf:APA91bGKDhFq3AJAuIlT2iIkqfoYqEmBaCKNFgynUhqxwqWT0t49TWNqYVdIctl1P8ibe0PtkwrG0iO4RHEZGWbqa_NsDbptamii4zaRhdOa46FBFSKrtfTUYEuNW9i9ZhVrELV9P2fo"
}'