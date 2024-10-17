#for creating python virtual environment requirements.txt file
function pyVirtualFreeze
  pyVirtualActivate
  pip freeze > requirements.txt
end
