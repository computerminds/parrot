define ohmyzsh::theme(
  $theme = 'clean',
  $user = $name
) {
  if $user == 'root' { $home = '/root' } else { $home = "${ohmyzsh::params::home}/${user}" }
  if $user {
    file_line { "${user}-${theme}-install":
      path    => "${home}/.zshrc",
      line    => "ZSH_THEME=\"${theme}\"",
      match   => '^ZSH_THEME',
      require => Ohmyzsh::Install[$user]
    }
  }
}
