# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2015 SUSE LLC
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
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

package consoles::console;
use strict;
use warnings;
require IPC::System::Simple;
use autodie qw(:all);

use Class::Accessor "antlers";
has backend => (is => "rw");

sub new {
    my ($class, $testapi_console, $args) = @_;
    my $self = bless({class => $class}, $class);
    $self->{testapi_console} = $testapi_console;
    $self->{args}            = $args;
    $self->{activated}       = 0;
    $self->init;
    return $self;
}

sub init {
    # nothing fancy
}

# SUT was e.g. rebooted
sub reset {
    my ($self) = @_;
    $self->{activated} = 0;
    return;
}

sub screen {
    my ($self) = @_;
    die "screen needs to be implemented in subclasses - $self->{class} does not\n";
    return;
}

# helper function
sub sshCommand {
    my ($self, $host) = @_;

    return "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root\@$host";
}

# to be overloaded
sub trigger_select {
}

sub select {
    my ($self) = @_;
    my $activated;
    if (!$self->{activated}) {
        $self->activate;
        $self->{activated} = 1;
        $activated = 1;
    }
    $self->trigger_select;
    return $activated;
}

sub activate {
    my ($self) = @_;
    return;
}

1;
