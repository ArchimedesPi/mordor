## Mordor is simple/stupid. All it does is 
* Install itself
## Then you can
* Install software (really git clone a sh script and run it)
* Parse dependancies from that script
* Install ALL the dependancies!
* And the software - don't forget that
## The command line syntax is:<br/>
### `> mordor <url> [...]`<br/>
## where <br/>
###	+ <url> is a URL to a git repo containing a file `Orcfile`.<br/>
####		+ <url> can be:<br/>
#####		|______ + `gist:<gitid>` Enter a gist ID, the gist should contain an Orcfile<br/>
#####		|______ + `git:<url>`	URL to a git repo, `git://` or `ssh://` or `https://` should work!<br/>
#####		|______ + `sauron:<packagename>` Get <packagename> from Sauron<br/>
#####		|______ + `balrog:<url>@<packagename>` Get <packagename> from git repo <url><br/>
###	+ The rest of the arguments are passed to the Orcfile<br/>
