#!/usr/bin/env sh

session=`loginctl session-status | head -n 1 | awk '{print $1}'`
loginctl terminate-session $session
