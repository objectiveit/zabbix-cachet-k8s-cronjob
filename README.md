# zabbix-cachet-k8s-cronjob docker container

# ENVIRONMENT variables to set

* ZABBIXAPI - zabbix api url {https://zabbix.domain/zabbix//api_jsonrpc.php}
* ZAPIUSER - zabbix api user
* ZAPIPASS - zabbi api password
* ITEMID - zabbix item id
* ITEMTYPE - item type, required for API requests to history
* CACHETHQURL - your cachethq url {https://cachethq.domain/api/v1}
* CACHET_TOKEN - your cachethq user token
<br>0 - numeric float; 
<br>1 - character; 
<br>2 - log; 
<br>3 - numeric unsigned; 
<br>4 - text. 
* VALUESCOUNT - zabbix values to get from history
* METRICID - cachet metricid
* CACHETAPI - cachet api url
* CACHET_TOKEN - cachet access token
