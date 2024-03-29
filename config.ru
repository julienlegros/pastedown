# This file is used by Rack-based servers to start the application.

require 'unicorn/worker_killer'

max_request_min = 500
max_request_max = 600

use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max

oom_min = (240) * (1024**2)
oom_max = (260) * (1024**2)

use Unicorn::WorkerKiller::Oom, oom_min, oom_max

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
