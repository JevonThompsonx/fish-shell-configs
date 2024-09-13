function bCreateVite
  echo "Cloning project template"
  set projectName $argv[1]
  git clone https://github.com/JevonThompsonx/vue_ts_template.git
  mv vue_ts_template $projectName
  cd $projectName
  echo "Installing dependencies"
  bun install
  rm -rf .git
end
