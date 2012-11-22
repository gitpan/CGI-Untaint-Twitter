#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'CGI::Untaint::Twitter' ) || print "Bail out!
";
}

diag( "Testing CGI::Untaint::Twitter $CGI::Untaint::Twitter::VERSION, Perl $], $^X" );
