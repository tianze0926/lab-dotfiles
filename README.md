`~/.config/chezmoi/chezmoi.yml`:

```yaml
data:
  proxy: true # or false
  proxy_git: true
```

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/tianze0926/lab-dotfiles
```

Put the following at the beginning (after the interactivity check) of `.bashrc`:

```sh
source ~/.local/share/chezmoi/.zsh_tmp_home.sh
```
```
```
