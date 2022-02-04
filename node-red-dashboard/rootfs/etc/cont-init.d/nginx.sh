#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Node-RED dashboard
# Configures NGINX for use with Node-RED dashboard
# ==============================================================================
declare dns_host
declare ingress_interface
declare ingress_port

ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf

dns_host=$(bashio::dns.host)
sed -i "s/%%dns_host%%/${dns_host}/g" /etc/nginx/includes/resolver.conf

config_port=$(bashio::config 'port')
sed -i "s/%%config_port%%/${config_port}/g" /etc/nginx/includes/upstream.conf
if bashio::config.true 'ssl'; then
    sed -i "s/%%schema%%/https/g" /etc/nginx/servers/ingress.conf
else
    sed -i "s/%%schema%%/http/g" /etc/nginx/servers/ingress.conf
fi
