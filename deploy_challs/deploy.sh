for chall in `find challs -mindepth 2 -type d`
do
  echo "- $chall"
  ctf challenge add $chall
  ctf challenge install $chall
done
