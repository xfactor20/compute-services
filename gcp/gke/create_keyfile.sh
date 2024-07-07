#!/usr/bin/bash
gcloud iam service-accounts keys create terraform-gke-keyfile.json --iam-account=${SVC_ACCT_NAME}@${GCP_PROJECT_ID}.iam.gserviceaccount.com