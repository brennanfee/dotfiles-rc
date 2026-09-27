#!/usr/bin/env sh

if type ksshaskpass > /dev/null 2>&1; then
  export SSH_ASKPASS
  SSH_ASKPASS=$(which ksshaskpass)
  export SSH_ASKPASS_REQUIRE=prefer
fi
