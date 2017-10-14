#!/bin/bash
curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/rkhtech/php7-awscli-codeigniter/trigger/6dd3d976-27f3-4296-8b47-922a67e35c60/
