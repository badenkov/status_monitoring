{pkgs, ...}: {
  env.SOLID_QUEUE_IN_PUMA = true;

  packages = [
    pkgs.libffi

    pkgs.inotify-tools
    pkgs.git
    pkgs.watchman

    pkgs.libyaml.dev
    pkgs.libxml2.dev
    pkgs.openssl.dev

    pkgs.vips # for active_storages
    pkgs.vips.dev # for active_storages

    pkgs.curl.dev # libcurl?
  ];

  languages.ruby.enable = true;
  languages.ruby.versionFile = ./.ruby-version;
  languages.ruby.bundler.enable = true;

  enterShell = ''
    export LD_LIBRARY_PATH="$DEVENV_PROFILE/lib:$LD_LIBRARY_PATH"
    export PATH="$(pwd)/bin:$PATH"
  '';

  enterTest = ''
    bundle install
    bin/rails test
  '';
}
