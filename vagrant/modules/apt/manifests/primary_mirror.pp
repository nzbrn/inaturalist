define apt::primary_mirror($country_code = $name, $ensure = 'present') {
  apt::source {"apt-primary_mirror-$name":
    source => "deb http://ftp.$country_code.debian.org/debian squeeze main non-free contrib",
    ensure => $ensure,
  }
}
