Been using zsh since around 98' and kept my config updated along with it.

It has some features but mostly stuff i need and i am happy with. It used to be
pretty slow but sped things up quite a bit :

## Benchmarks

Using [`zshbench`](https://github.com/romkatv/zsh-bench)

### On fast Linux Laptop (arch/ssd btrfs/encrypted) with p10k prompt :

```
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=20.689
first_command_lag_ms=154.556
command_lag_ms=21.533
input_lag_ms=2.067
exit_time_ms=231.670
```

### Macbook M1:

```
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=22.427
first_command_lag_ms=159.541
command_lag_ms=14.546
input_lag_ms=2.657
exit_time_ms=237.649
```



### RPI SD card : 

```
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=0
first_prompt_lag_ms=227.512
first_command_lag_ms=243.312
command_lag_ms=61.501
input_lag_ms=4.515
exit_time_ms=185.375
```

## Plugin support

I was using zplug which was very slow and didn't need 99% of the things it does. So I wrote my own called `vtplug` for "very tiny plugin manager" located [here](https://github.com/chmouel/zsh-config/blob/master/functions/vtplug).

The way it works, you simply add the plugin to the array ZSH_PLUGINS, for example if you want to install [alias-zsh](https://github.com/xylous/alias-zsh) you add this to your local file :

```shell
ZSH_PLUGINS+=xylous/alias-zsh
```

and run :

```
vtplug
````

and it would grab the repo put in your cahce dir and source the plugin file.

By default it loads the standard `$plugin_name.plugin.zsh` but if you want some other file just add a colon after :

```shell
ZSH_PLUGINS+=repo/plugin:another.file.to.source
```

support just github

if you want to update the repo you just add a `-u`

maybe will add more features if needed but this fill up my "niche" use case.

## Enabling powerlevel10k prompt 

if you have the package just install it. If you want to install you can do this with vtplug, edit your local file with vih and add :

```
ZSH_PLUGINS+=romkatv/powerlevel10k
powerlevel_prompt=${cachedir}/repos/romkatv/powerlevel10k/powerlevel10k.zsh-theme
```

reload with `so` and run :

```
vtplug
```

relog into your shell and you should have powerlevel10k. You can overwrite some config in your -post local file
