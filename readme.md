# dotfiles

nyker-goto dotfiles

## Prepare

install.sh を実行して home に dot-files をコピー (まだ全然ちゃんと書いてないので動かない)

```bash
sh ./install.sh
```

## MacOS

zplug を `~/.zplug` にインストール

```bash
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
```

## Ubuntu

zsh をインストール

```bash
sudo apt-get install zsh

which zsh # これで path が表示されれば OK
```

自分の default shell を zsh に変更

```bash
chsh -s $(which zsh)
```
