package MoWitness::Controller::Witness;
use Mojo::Base 'Mojolicious::Controller';
use IO::Socket::INET6;
use IO::Select;

sub checkPort {
  my $address = shift;
  my $port = shift;
  my $protocol = shift;

  my $socket = new IO::Socket::INET6 (
    PeerAddr => $address,
    PeerPort => $port,
    Proto => $protocol,
  ) or return 0;
  if ($protocol eq 'udp') {
    $socket->send('check',0);
    my $select = new IO::Select();
    $select->add($socket);
    my @socket = $select -> can_read(1);
    if (@socket == 1) {
        $socket->recv(my $temp, 1, 0) or return 0;
        return 1;
    }
    return 1;
  } else {
    return 1;
  }
     
}

# This action will check port connectivity
sub check {
  my $self = shift;
  
  my $user_agent = $self->req->headers->user_agent;

  my $address;

  # Fetch config
  my $config = $self->config;

  if (my $masteraddress = $config->{'check_service'}{$user_agent}{'masteraddress'}) {
    my $slaveaddress = $config->{'check_service'}{$user_agent}{'slaveaddress'};
    my $port = $config->{'check_service'}{$user_agent}{'port'};
    my $protocol = $config->{'check_service'}{$user_agent}{'protocol'};

    my $checkmaster = checkPort( $address = $masteraddress, $port, $protocol );
    my $checkslave = checkPort( $address = $slaveaddress, $port, $protocol );

    $self->render(text => $checkmaster.$checkslave);
  } else {
    $self->render(text => "Resource not found\n", status => 404 );
  }

}

sub failure {

  my $self = shift;

  $self->render(text => "Resource not found\n", status => 404 );

}

1;
