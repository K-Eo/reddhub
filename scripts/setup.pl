#!/usr/bin/perl

$base_path = "tools";

sub prepare {
  if (-d $base_path) {
    print "Tools directory ready.\n";
  } else {
    mkdir($base_path) or die("Couldn't create tools directory.\n");
    print "Tools directory created.\n";
  }
}

sub setup_heroku {
  print "====================\n";
  print "Download Heroku\n";

  my $heroku = "heroku.tar.gz";

  if (-f "$base_path/$heroku") {
    print "File heroku.tar.gz already cached.\n";
  } else {
    print "Downloading heroku.tar.gz\n";
    system("wget -nv -O $base_path/$heroku https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz") == 0
      or die "Failed to download herokur.tar.gz.\n";
  }

  print "Configure Heroku\n";

  system("sudo mkdir -p /usr/local/lib /usr/local/bin") == 0
    or die "Couldn't create heroku install directory.\n";

  system("sudo tar -xzf $base_path/$heroku -C /usr/local/lib") == 0
    or die "Couldn't extract heroku.\n";

  system("sudo ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku") == 0
    or die "Couldn't create link to heroku bin.\n";
  
  print "Heroku ready\n";
}

sub setup_gems {
  print "====================\n";
  print "Install gems\n";

  system("gem install bundler --no-ri --no-rdoc") == 0 or die "Failed to install bundler.\n";
  system("bundle install --jobs \$(nproc) --path vendor/bundle") == 0 or die "Failed to install gems.\n";

  print "Gems ready\n";
}

sub setup_yarn {
  print "====================\n";
  print "Install yarn packages\n";

  system("yarn install") == 0 or die "Failed to install yarn packages.\n";

  print "Yarn ready\n";
}

prepare();
setup_heroku();
setup_gems();
setup_yarn();


