
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Scalar::Util" => 0,
    "Test::More" => "0.94",
    "perl" => "5.004"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Communicate with Redmine thought the API",
  "dist_author" => [
    "celogeek <me\@celogeek.com>"
  ],
  "dist_name" => "Redmine-API",
  "dist_version" => "0.01",
  "license" => "perl",
  "module_name" => "Redmine::API",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Data::Dumper" => 0,
    "JSON::XS" => 0,
    "Moo" => 0,
    "Net::HTTP::Spore" => 0,
    "perl" => "5.006",
    "strict" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
