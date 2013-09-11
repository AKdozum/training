package DenaTraining::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use Teng;
use Teng::Schema::Loader;


filter 'set_title' => sub {
  my $app = shift;
  sub {
    my ( $self, $c )  = @_;
    $c->stash->{site_name} = __PACKAGE__;
    $app->($self,$c);
  }
};

get '/' => [qw/set_title/] => sub {
  my ( $self, $c )  = @_;

  $c->render('index.tx', { greeting => "Hello" });
};

post '/save' => sub {
  my ($self, $c) = @_;
  my $result = $c->req->validator([
      'tbox' => {
        rule => [
          ['NOT_NULL','Please enter something!'],
        ],
      }
    ]);
  if ( $result->has_error ) {
    return $c->render_json({ 
        error => 1, 
        messages => $result->errors });
  }
  my $teng = &init;
 
  $teng->do(q{
    CREATE TABLE IF NOT EXISTS `comments` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `comment` text NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB  DEFAULT CHARSET=utf8
    });

  $teng->insert('comments' => {
      'comment' => $result->valid->get('tbox')
    });
  $c->render('save.tx', { 
      text => $result->valid->get('tbox') 
    });
};


sub init {
  my $self = shift;
  my $dsn    = 'dbi:mysql:dena_training';
  my $user   = 'root';
  my $passwd = '';
  my $dbh = DBI->connect($dsn, $user, $passwd, {
      'mysql_enable_utf8' => 1,
    });
  my $teng = Teng::Schema::Loader->load(
    'dbh'       => $dbh,
    'namespace' => 'MyApp::DB',
  );

  return $teng;
}


1;

