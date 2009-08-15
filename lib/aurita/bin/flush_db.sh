#!/bin/bash

ps aux | grep postgres | awk '{print $2}' | xargs kill -15; 
su - postgres -c '/usr/lib/postgresql/8.1/bin/postmaster -D /var/lib/postgresql/8.1/aurita_utf8 &'

