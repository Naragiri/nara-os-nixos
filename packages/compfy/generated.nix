# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  compfy = {
    pname = "compfy";
    version = "1.7.2";
    src = fetchFromGitHub {
      owner = "allusive-dev";
      repo = "compfy";
      rev = "1.7.2";
      fetchSubmodules = false;
      sha256 = "sha256-7hvzwLEG5OpJzsrYa2AaIW8X0CPyOnTLxz+rgWteNYY=";
    };
  };
}
