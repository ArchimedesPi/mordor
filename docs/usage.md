## Mordor is very simple
*Disclaimer: this is sort of a TODO reference of what I want to accomplish with the command line options*

## The command line syntax is:<br/>
### `> mordor <action> <url> [options...]`<br/>
<hr/><hr/>
<pre>
`<action>`
    |_ Package Management
    |     |_________ `install`: install a package
    |     |_________ `remove`: remove a package
    |     |_________ `upgrade`: upgrade a package
    |
    |_ Package Manager Management
          |________ `update`: update Mordor
          |________ `zap`: uninstall Mordor (leave cache/config)
          |________ `slay-burn-fire-kill`: just kill the whole deal (i.e. rm -rfv $INSTALLATION_PREFIX/mordor)
</pre>
<hr/>
<pre>
`<url>`
  |___ `<gistid>` install from gist `gistid`
  |___ `<giturl>$[branch]@[commit]` install from git repo `giturl`, and/or branch `branch`, and/or commit hash `commit`
  |___ `<giturl>$[branch]@[commit]:<packagename>` same as above, but install `packagename` from that repo
  |___ `<packagename>` pull package from sauron
</pre>
