#!/usr/bin/perl
use strict;

use LWP::UserAgent;
use IO::Socket::SSL qw();
use JSON;
use Data::Dumper;

my $ZABBIXAPI = $ENV{'ZABBIXAPI'};
my $ZAPIUSER = $ENV{'ZAPIUSER'};
my $ZAPIPASS = $ENV{'ZAPIPASS'};
my $ITEM_ID = $ENV{'ITEMID'};
my $METRIC_ID = $ENV{'METRICID'};
my $VALUES_COUNT = $ENV{'VALUESCOUNT'} || 1;
my $ITEM_TYPE = $ENV{'ITEMTYPE'};
my $CACHET_API = $ENV{'CACHETAPI'};
my $CACHET_TOKEN = $ENV{'CACHET_TOKEN'};

my $ID = 0;
my $AUTH = '';
my $ua = LWP::UserAgent->new();
$ua->default_header('Content-Type' => 'application/json-rpc');
# Auth ######################################
my $authRequest = {
    jsonrpc => '2.0',
    method  => 'user.login',
    params  => {
        user        => $ZAPIUSER,
        password    => $ZAPIPASS,
    },
    id      => ++$ID,
};
my $authRequestJson = encode_json $authRequest;

my $respAuth = $ua->post($ZABBIXAPI, Content => $authRequestJson);
if ($respAuth->is_success) {
    my $responseJson = decode_json $respAuth->content;
    $AUTH = $responseJson->{result};
    die "Zabbix API Authentication Error" if length $AUTH == 0;
} else {
    die "Zabbix API HTTP Connection Error";
}

# Get item history values ##############################
my $postBody = {
    jsonrpc => '2.0',
    method  => 'history.get',
    params  => {
        output  => "extend",
        itemids => $ITEM_ID,
        history => $ITEM_TYPE,
        limit   => $VALUES_COUNT,
    },
    id      => ++$ID,
    auth    => $AUTH
};
my $postBodyJson = encode_json $postBody;
my $respItems = $ua->post($ZABBIXAPI, Content => $postBodyJson);

my $responseFromZabbix;
if ($respItems->is_success) {
    $responseFromZabbix = decode_json $respItems->content;
    print Dumper($responseFromZabbix);
} else {
    die "Zabbix API HTTP Co nnection Error";
}

# Send to Cachet
my $uaCachet = LWP::UserAgent->new(
    ssl_opts => {
        SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE,
        verify_hostname => 0,
    }
);
$uaCachet->default_header('Content-Type' => 'application/json');
$uaCachet->default_header('X-Cachet-Token' => $CACHET_TOKEN);

foreach my $item (@{$responseFromZabbix->{result}}) {
    my $body = {
        value => $item->{value},
        timestamp => $item->{clock},
    };
    my $resp = $uaCachet->post($CACHET_API . "metrics/$METRIC_ID/points", Content => encode_json $body);
    print $resp->content;
}

