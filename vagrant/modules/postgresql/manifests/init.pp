class postgresql {

  package { "postgresql-8.4":
    provider => aptitude,
    require => Exec["aptitude_update"],
    ensure => present,
  }
}
