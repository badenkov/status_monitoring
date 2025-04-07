{ pkgs, lib, config, inputs, ... }:

{
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

  enterTest = ''
    bundle install
    bin/rails test
  '';
}
