define apt::source ($source, $ensure = present) {

  file { "/etc/apt/sources.list.d/$name.list":
    content => $source,
    ensure  => $ensure,
    before  => Exec["aptitude_update"],
    notify  => Exec["aptitude_update"],
  }

}
