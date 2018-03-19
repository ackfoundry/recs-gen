module OptionParser
  DEFAULTS = {
    'task'      => 'ecs-nginx-proxy',
    'host-var'  => 'virtual_host',
    'signal'    => 'nginx -s reload',
    'frequency' => 30,
    'loglevel'  => 'info',
    'once'      => false
  }.freeze

  def self.parse
    opts = Slop.parse do |o|
      o.string '-r'   , '--region'                         , 'AWS Region'
      o.string '-c'   , '--cluster'                        , 'ECS cluster name'

      o.string '-t'   , '--template'                       , 'Path to template file'
      o.string '-o'   , '--output'                         , 'Path to output file'

      o.string '-k'   , '--task'                           , 'Name of ECS task containing nginx'       , default: DEFAULTS['task']
      o.string '-h'   , '--host-var'                       , 'Which ENV var to use for the hostname'   , default: DEFAULTS['host-var']
      o.string '-s'   , '--signal'                         , 'Command to run to signal change'         , default: DEFAULTS['signal']

      o.integer '-f'  , '--frequency'                      , 'Time in seconds between polling.'        , default: DEFAULTS['frequency']
      o.string  '-l'  , '--loglevel'                       , 'Set the logging level'                   , default: DEFAULTS['loglevel']
      o.bool    '-1'  , '--once'                           , 'Only execute the template once and exit' , default: DEFAULTS['once']

      o.bool '--help' , 'Print usage information and exit' , default: false

      o.on '--version', 'print ecs-rgen version' do
        puts Ecsrgen::VERSION
        exit
      end
    end

    if opts.help?
      puts opts
      exit
    end

    opts
  end
end
