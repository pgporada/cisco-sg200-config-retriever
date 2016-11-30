# Overview

[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

Originally [posted on Reddit](https://www.reddit.com/r/shell/comments/2hw0gh/need_help_automating_config_backups_of_switches/) asking for help ripping out configs from the [Cisco SG200](http://www.cisco.com/c/en/us/products/collateral/switches/small-business-200-series-smart-switches/data_sheet_c78-634369.html) _smart_ (read: dumb) 26/50 port switch.

Use this script at your own risk.

- - - -
# Usage

You will need to edit the script to put in a username/password on the **LOGIN=** line.

!!! WARNING !!! This line will be sent unencrypted over the wire as it's using http and not https.

Retrieve the config from a single switch

    ./cisco-sg200-config-retriever.sh 10.1.1.2

Retrieve the config from multiple switches

    for i in 10.1.1.{2,3,4}; do ./cisco-sg200-config-retriever.sh ${i}; done

- - - -
# License and Author Information
MIT

Thank you to [@hufman](https://github.com/hufman) for actually using this thing years later :D

(c) 2014-2016 [Phil Porada](http://philporada.com)
