Been using zsh since around 98' and kept my config updated along with it.

It has some features but mostly stuff i need and i am happy with. It used to be
pretty slow but sped things up quite a bit :

## Benchmarks

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



### RPI SD card : 

zshbench

```
==> benchmarking login shell of user chmouel ...
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=364.082
first_command_lag_ms=380.892
command_lag_ms=165.164
input_lag_ms=4.558
exit_time_ms=178.200
```

still a long way from bash tho which is not customized at all : 

```bash
% for i ({1..5}) time bash -i -c 'exit'
bash -i -c 'exit'  0.01s user 0.00s system 92% cpu 0.013 total
bash -i -c 'exit'  0.00s user 0.01s system 90% cpu 0.013 total
bash -i -c 'exit'  0.02s user 0.00s system 96% cpu 0.020 total
bash -i -c 'exit'  0.01s user 0.00s system 93% cpu 0.015 total
bash -i -c 'exit'  0.02s user 0.00s system 96% cpu 0.020 total
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
