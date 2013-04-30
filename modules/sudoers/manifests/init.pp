class sudoers {
  augeas { "sudokeyforward":
    context => "/files/etc/sudoers",
	onlyif  => 'match Defaults/env_keep/var[.="SSH_AUTH_SOCK"] size == 0',
	changes => [
	  'ins Defaults after Defaults[last()]',
	  'clear Defaults[last()]/env_keep',
	  'clear Defaults[last()]/env_keep/append',
	  'set Defaults[last()]/env_keep/var "SSH_AUTH_SOCK"',
	],
  }
}
