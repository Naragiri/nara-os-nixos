# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  sddm-sugar-candy = {
    pname = "sddm-sugar-candy";
    version = "v1.6";
    src = fetchFromGitHub {
      owner = "Kangie";
      repo = "sddm-sugar-candy";
      rev = "v1.6";
      fetchSubmodules = false;
      sha256 = "sha256-p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
    };
  };
}
