trustedkeys.kbx:
	cat *.asc | \
	  gpg --no-default-keyring --no-options --trust-model=always \
	      --keyring ${PWD}/trustedkeys.kbx \
	      --import -

list:
	gpg --no-default-keyring --trust-model=always \
		--keyring ${PWD}/trustedkeys.kbx \
		--list-keys

clean:
	rm trustedkeys.kbx

.PHONY: clean
