function bCreateReactFullStack
  set projectName $argv[1]
  
  if test -n "$projectName"
    echo "Cloning..."
    git clone https://github.com/JevonThompsonx/react_ts_template_fullstack.git
    mv react_ts_template_fullstack $projectName
    cd $projectName
    bun install
    echo "Done!"
    echo "Remember to change project name in package.json"
    echo "Happy coding!!"
  else
    echo "Error! You probably didn't pass in a project name. Try again."
  end
end

