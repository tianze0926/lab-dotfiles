`~/.config/chezmoi/chezmoi.yml`:

```yaml
data:
  proxy: true # or false
```

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/tianze0926/lab-dotfiles
```
