function bCreateVite
  set projectName $argv[1]
  bun create vite $projectName --template vue-ts
  cd $projectName
  bun install
end
