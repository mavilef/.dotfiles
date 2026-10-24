# Dotfiles na home com Git bare

Este repositório usa caminhos relativos à home: `.bashrc` e `.vim/`
(vimrc, vim-airline e tema vim-code-dark). O diretório `~/.dotfiles` guarda
somente os metadados do Git; os arquivos de configuração ficam em `$HOME`.
Git e Vim precisam estar instalados separadamente.

## Instalar

Execute no Bash. O destino `~/.dotfiles` não deve existir:

```bash
git clone --bare https://github.com/mavilef/.dotfiles.git "$HOME/.dotfiles"
alias dotfiles-config='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
dotfiles-config config --local status.showUntrackedFiles no
dotfiles-config config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dotfiles-config checkout
```

O checkout também coloca este README em `~/DOTFILES-README.md`. Se houver
arquivos existentes em conflito, o Git interromperá o checkout. Mova os
arquivos indicados para um backup fora dos caminhos versionados e execute
`dotfiles-config checkout` novamente. Não use checkout forçado. Confira
também se um `~/.vimrc` existente está substituindo o `~/.vim/vimrc` instalado.

Para persistir o comando, adicione esta linha uma única vez ao `~/.bashrc`
(ou ao `~/.zshrc`, se usar Zsh):

```bash
alias dotfiles-config='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
```

Abra um novo terminal e confira `dotfiles-config status`. Reabra o Vim para
carregar a configuração.

## Migrar um clone normal sem perder commits locais

Após editar e commitar no clone normal, é possível instalar sem rede.
Por exemplo, se o clone estiver em `~/projects/dotfiles-edit`:

```bash
git -C "$HOME/projects/dotfiles-edit" status --short
git clone --bare --no-hardlinks "$HOME/projects/dotfiles-edit" "$HOME/.dotfiles"
alias dotfiles-config='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
dotfiles-config remote set-url origin https://github.com/mavilef/.dotfiles.git
dotfiles-config config --local status.showUntrackedFiles no
dotfiles-config config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dotfiles-config checkout
dotfiles-config status
```

Antes da migração, o status do clone normal deve estar limpo: arquivos não
commitados não são transferidos. Compare `git -C ~/projects/dotfiles-edit
rev-parse HEAD` com `dotfiles-config rev-parse HEAD`. Só apague o clone normal
depois de confirmar o mesmo commit, checkout concluído e ausência de arquivos
locais a preservar. O clone bare independente conserva os commits mesmo sem
push. Persista o alias como descrito acima.

## Uso diário

```bash
dotfiles-config status
dotfiles-config diff
dotfiles-config add "$HOME/.bashrc" "$HOME/.vim/vimrc"
dotfiles-config commit -m "Atualiza configurações de Bash e Vim"
dotfiles-config push -u origin HEAD
```

Adicione caminhos específicos: `add .` executado na home pode incluir arquivos
pessoais e segredos. `status.showUntrackedFiles no` apenas oculta arquivos não
versionados do status; não impede que sejam adicionados.

Para atualizar a branch atual quando a árvore estiver limpa:

```bash
dotfiles-config fetch origin
dotfiles-config merge --ff-only "origin/$(dotfiles-config branch --show-current)"
```

O push por HTTPS requer autenticação configurada. Se preferir sua chave SSH:

```bash
dotfiles-config remote set-url origin git@github.com:mavilef/.dotfiles.git
```
