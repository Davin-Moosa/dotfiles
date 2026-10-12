function git-auth
  eval (ssh-agent -c)
  ssh-add ~/.ssh/id_gitauth
end
