trustedkeys.kbx:
	cat *.asc | \
	  gpg --no-default-keyring --no-options --trust-model=always \
	      --keyring ${PWD}/trustedkeys.kbx \
	      --import -
clean:
	rm trustedkeys.kbx

.PHONY: clean
