# Config for ngx_openresty
#
class openresty::config {
  require boxen::config

  $configdir  = "${boxen::config::configdir}/openresty"
  $configfile = "${configdir}/nginx.conf"
  $datadir    = "${boxen::config::datadir}/openresty"
  $executable = "${boxen::config::homebrewdir}/bin/openresty"
  $logdir     = "${boxen::config::logdir}/openresty"
  $pidfile    = "${datadir}/openresty.pid"
  $sitesdir   = "${configdir}/sites"
}
