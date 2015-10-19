class ohmyzsh::params {
  case $::operatingsystem {
    default: {
      $zsh = '/usr/bin/zsh'
      $home = '/home'
    }
  }
}
