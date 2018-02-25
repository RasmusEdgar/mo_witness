package MoWitness;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/check')->to('Witness#check');

  # Reject all other stuff
  $r->any('/')->to(controller => 'Witness', action => 'failure');
  $r->any('/*name')->to(controller => 'Witness', action => 'failure');
}

1;
