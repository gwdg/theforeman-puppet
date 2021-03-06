# Default parameters
class puppet::params {

  include foreman::params

  # Basic config
  $version             = 'present'
  $user                = 'puppet'
  $group               = 'puppet'
  $dir                 = '/etc/puppet'
  $port                = 8140
  $listen              = false
  $pluginsync          = true
  $splay               = false
  $runinterval         = '1800'
  $runmode             = 'service'
  $agent_noop          = false
  $show_diff           = false
  $ca_server           = false

  # Need your own config templates? Specify here:
  $agent_template  = 'puppet/puppet.conf.erb'
  $auth_template   = 'puppet/auth.conf.erb'
  $nsauth_template = 'puppet/namespaceauth.conf.erb'

  # Will this host be a puppetmaster?
  $server                    = false
  $server_vardir             = '/var/lib/puppet'
  $server_ca                 = true
  $server_reports            = 'foreman'
  $server_passenger          = true
  $server_service_fallback   = true
  $server_passenger_max_pool = 12
  $server_httpd_service      = 'httpd'
  $server_external_nodes     = '/etc/puppet/node.rb'

  # Need a new master template for the server?
  $server_template = 'puppet/server/puppet.conf.erb'

  # The script that is run to determine the reported manifest version. Undef
  # means we determine it in server.pp
  $server_config_version      = undef

  # Set 'false' for static environments, or 'true' for git-based workflow
  $server_git_repo            = false

  # Static environments config, ignore if the git_repo is 'true'
  # What environments do we have
  $server_environments        = ['development', 'production']
  # Where we store our puppet environments
  $server_envs_dir            = "${dir}/environments"
  # Where remains our manifests dir
  $server_manifest_path       = "${dir}/manifests"
  # Modules in this directory would be shared across all environments
  $server_common_modules_path = ["${server_envs_dir}/common", '/usr/share/puppet/modules']

  # Dynamic environments config, ignore if the git_repo is 'false'
  # Path to the repository
  $server_git_repo_path       = "${server_vardir}/puppet.git"
  # Override these if you need your own hooks
  $server_post_hook_content   = 'puppet/server/post-receive.erb'
  $server_post_hook_name      = 'post-receive'

  # Do you use storeconfigs? (note: not required)
  # - false if you don't
  # - active_record for 2.X style db
  # - puppetdb for puppetdb
  $server_storeconfigs_backend = false

  # Passenger config
  $server_app_root = "${dir}/rack"
  $server_ssl_dir  = "${server_vardir}/ssl"

  $server_package     =  $::operatingsystem ? {
    /(Debian|Ubuntu)/ => ['puppetmaster-common','puppetmaster'],
    default           => ['puppet-server'],
  }
  $client_package     = $::operatingsystem ? {
    /(Debian|Ubuntu)/ => ['puppet-common','puppet'],
    default           => ['puppet'],
  }

  # This only applies to puppet::cron
  $cron_range          = 60 # the maximum value for our cron
  $cron_interval       = 2  # the amount of values within the $cron_range

  # Only use 'puppet cert' on versions where puppetca no longer exists
  if versioncmp($::puppetversion, '3.0') < 0 {
    $puppetca_path = '/usr/sbin'
    $puppetca_bin  = 'puppetca'
    $puppetrun_cmd = '/usr/sbin/puppetrun'
  } else {
    $puppetca_path = '/usr/bin'
    $puppetca_bin = 'puppet cert'
    $puppetrun_cmd = '/usr/bin/puppet kick'
  }

  $puppetca_cmd = "${puppetca_path}/${puppetca_bin}"

  # Puppet service name
  if $::operatingsystem == 'Fedora' and $::operatingsystemrelease >= 19 {
    $service_name = 'puppetagent'
  } else {
    $service_name = 'puppet'
  }
}
