#/usr/bin/env bash

YC_TOKEN=$($HOME/yandex-cloud/bin/yc iam create-token)
YC_CLOUD_ID=$($HOME/yandex-cloud/bin/yc config get cloud-id)
YC_FOLDER_ID=$($HOME/yandex-cloud/bin/yc config get folder-id)

echo $(jq --null-input \
          --arg token "$YC_TOKEN" \
          --arg cloud_id "$YC_CLOUD_ID" \
          --arg folder_id "$YC_FOLDER_ID" \
          '{"token": $token, "cloud_id": $cloud_id, "folder_id": $folder_id}')
