./filebrowser config init \
  --auth.method=noauth \
  --port=62023 \
  --root=/
./filebrowser users add admin admin \
  --perm.admin=true
