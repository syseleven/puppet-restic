class { 'restic':
  # Because it doesn't work in acceptance testing
  init_repo    => false,
  repositories => {
    'backup1' => {
      backup_path  => '/absolute/path',
      backup_timer => 'daily',
      bucket       => 'bucket_name/bucket_dir',
      forget       => {
        'keep-last' => 10,
      },
      forget_timer => 'daily',
      host         => 'host.example.com',
      id           => 's3id',
      key          => 's3key',
      password     => 'somegoodpassword',
      type         => 's3',
    },
  },
}
