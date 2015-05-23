#!/bin/bash

# Starting Elasticsearch
/etc/init.d/elasticsearch restart

# Starting Logstash
/etc/init.d/logstash restart

# Starting Kibana
bin/kibana
