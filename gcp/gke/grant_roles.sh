#!/bin/bash

gcloud projects add-iam-policy-binding majestic-hybrid-423401-t7 --member serviceAccount:morpheus-lumerin-gke@majestic-hybrid-423401-t7.iam.gserviceaccount.com --role roles/compute.viewer
gcloud projects add-iam-policy-binding majestic-hybrid-423401-t7 --member serviceAccount:morpheus-lumerin-gke@majestic-hybrid-423401-t7.iam.gserviceaccount.com --role roles/container.clusterAdmin
gcloud projects add-iam-policy-binding majestic-hybrid-423401-t7 --member serviceAccount:morpheus-lumerin-gke@majestic-hybrid-423401-t7.iam.gserviceaccount.com --role roles/container.developer
gcloud projects add-iam-policy-binding majestic-hybrid-423401-t7 --member serviceAccount:morpheus-lumerin-gke@majestic-hybrid-423401-t7.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding majestic-hybrid-423401-t7 --member serviceAccount:morpheus-lumerin-gke@majestic-hybrid-423401-t7.iam.gserviceaccount.com --role roles/iam.serviceAccountAdmin
gcloud projects add-iam-policy-binding majestic-hybrid-423401-t7 --member serviceAccount:morpheus-lumerin-gke@majestic-hybrid-423401-t7.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin