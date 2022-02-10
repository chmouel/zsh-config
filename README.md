Been using zsh since around 98' and kept my config updated along with it.

It has some features but mostly stuff i need and i am happy with. It used to be
pretty slow but sped things up quite a bit :

## Benchmarks

On fast Linux Laptop (arch/ssd btrfs/encrypted) :

```bash
% for i ({1..5}) time zsh -i -c 'exit'
zsh -i -c 'exit'  0.06s user 0.04s system 103% cpu 0.102 total
zsh -i -c 'exit'  0.06s user 0.05s system 102% cpu 0.108 total
zsh -i -c 'exit'  0.08s user 0.04s system 102% cpu 0.118 total
zsh -i -c 'exit'  0.08s user 0.04s system 103% cpu 0.118 total
zsh -i -c 'exit'  0.06s user 0.05s system 103% cpu 0.107 total
```

Macbook M1:

```bash
% for i ({1..5}) time zsh -i -c 'exit'
zsh -i -c 'exit'  0.06s user 0.03s system 94% cpu 0.093 total
zsh -i -c 'exit'  0.03s user 0.02s system 91% cpu 0.053 total
zsh -i -c 'exit'  0.03s user 0.02s system 94% cpu 0.050 total
zsh -i -c 'exit'  0.03s user 0.02s system 95% cpu 0.049 total
zsh -i -c 'exit'  0.03s user 0.02s system 95% cpu 0.049 total
```

zshbench

```
==> benchmarking login shell of user chmouel ...
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=159.133
first_command_lag_ms=161.448
command_lag_ms=77.540
input_lag_ms=1.369
exit_time_ms=202.910
```

zshbench p10k

```
==> benchmarking login shell of user chmouel ...
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=131.359
first_command_lag_ms=136.320
command_lag_ms=16.826
input_lag_ms=3.083
exit_time_ms=210.400
```

on slow RPI SD card : 

```bash
% for i ({1..5}) time zsh -i -c 'exit'
zsh -i -c 'exit'  0.15s user 0.11s system 99% cpu 0.266 total
zsh -i -c 'exit'  0.13s user 0.09s system 99% cpu 0.224 total
zsh -i -c 'exit'  0.11s user 0.12s system 99% cpu 0.224 total
zsh -i -c 'exit'  0.07s user 0.15s system 99% cpu 0.223 total
zsh -i -c 'exit'  0.09s user 0.13s system 99% cpu 0.224 total
```

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
