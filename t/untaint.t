#!perl -w

use strict;
use warnings;
use Test::More;

eval 'use Test::CGI::Untaint';

if($@) {
        plan skip_all => 'Test::CGI::Untaint required for testing extraction handler';
} else {
        plan tests => 4;

        use_ok('CGI::Untaint::Twitter');

        is_extractable('nigelhorne', 'devon', 'Twitter');
        is_extractable('@nigelhorne', 'devon', 'Twitter');
        unextractable('&^&', 'Twitter');
}

