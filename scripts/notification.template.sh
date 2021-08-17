#!/bin/bash

# Copyright 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

if [ ${enable_bastion_notification} ]; then
  sudo al-config -T ${topic_id}
else
  echo 'ONS notification not enabled'
fi