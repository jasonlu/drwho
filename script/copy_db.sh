#!/bin/bash
mysqldump -u onlynet -p -h onlynet.biz onlynet_prod --set-gtid-purged=OFF | mysql -u onlynet -p onlynet_dev
mysqldump -u onlynet -p onlynet_dev --set-gtid-purged=OFF | mysql -u onlynet -p onlynet_prod