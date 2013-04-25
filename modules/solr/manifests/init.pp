import 'classes/*'

class solr (
  $backend = $solr::params::backend,
  $home_dir = $solr::params::solr_home_dir,
  $data_dir = $solr::params::solr_data_dir,
  $ensure = $solr::params::ensure
) inherits solr::params {
  include solr::packages
  include solr::files
  include solr::config
  include solr::services

  Class['solr::packages'] -> Class ['solr::files'] -> Class['solr::config'] -> Class['solr::services']
}
