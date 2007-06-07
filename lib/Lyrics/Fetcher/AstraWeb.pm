#
# AstraWeb - lyrics.astraweb.com implementation
#
# Copyright (C) 2003 Sir Reflog <reflog@mail15.com>
# All rights reserved.
#
# Maintainership of Lyrics::Fetcher transferred in Feb 07 to BIGPRESH
# (David Precious <davidp@preshweb.co.uk>)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

package Lyrics::Fetcher::AstraWeb;

use strict;
use WWW::Mechanize;
use URI::URL;
use vars qw($VERSION);

$VERSION = '0.3';

sub fetch($$$){
    my($self,$artist, $title) = @_;
    my $agent = WWW::Mechanize->new();
    my($sartist) = join ("+", split(/ /, $artist));
    my($stitle) = join ("+", split(/ /, $title));
    $agent->get("http://search.lyrics.astraweb.com/?word=$sartist+$stitle");
    #$agent->form(1) if $agent->forms and scalar @{$agent->forms};
    if(grep { $_->text() =~ /$title/ }@{$agent->links}) {
        $agent->follow_link(text_regex => qr((?-xism:$title)));
        if(grep { $_->text() =~ /Printable/ }@{$agent->links}) {
		    $agent->follow_link(text_regex => qr((?-xism:Printable)));
	}else{
	    $Lyrics::Fetcher::Error = 'Bad page format';
	    return;
		
	}
    }else{
    $Lyrics::Fetcher::Error = 'Cannot find such title';
    return;
    }
    return $agent->content =~  /<blockquote>(.*)<\/blockquote>/ && $1;
}

1;

=head1 NAME

Lyrics::Fetcher::AstraWeb - Get song lyrics from lyrics.astraweb.com

=head1 SYNOPSIS

  use Lyrics::Fetcher;
  print Lyrics::Fetcher->fetch("<artist>","<song>","AstraWeb");

  # or, if you want to use this module directly without Lyrics::Fetcher's
  # involvement:
  use Lyrics::Fetcher::AstraWeb;
  print Lyrics::Fetcher::AstraWeb->fetch('<artist>', '<song>');


=head1 DESCRIPTION

This module tries to get song lyrics from lyrics.astraweb.com.  It's designed 
to be called by Lyrics::Fetcher, but can be used directly if you'd prefer.


=head1 BUGS

Probably. If you find any bugs, please let me know.


=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it under 
the same terms as Perl itself.


=head1 AUTHOR

David Precious E<lt>davidp@preshweb.co.ukE<gt>



=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by David Precious

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.

Legal disclaimer: I have no connection with the owners of astraweb.com.
Lyrics fetched by this script may be copyrighted by the authors, it's up to 
you to determine whether this is the case, and if so, whether you are entitled 
to request/use those lyrics.  You will almost certainly not be allowed to use
the lyrics obtained for any commercial purposes.

=cut
