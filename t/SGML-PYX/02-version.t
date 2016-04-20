# Pragmas.
use strict;
use warnings;

# Modules.
use SGML::PYX;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($SGML::PYX::VERSION, 0.03, 'Version.');
