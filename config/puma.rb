# frozen_string_literal: true

puma_workers = ENV['MEYVN_PUMA_WORKERS']
puma_workers = 4 if puma_workers.blank?
workers puma_workers

puma_threads_min = ENV['MEYVN_PUMA_THREADS_MIN']
puma_threads_min = 0 if puma_threads_min.blank?
puma_threads_max = ENV['MEYVN_PUMA_THREADS_MAX']
puma_threads_max = 8 if puma_threads_max.blank?
threads puma_threads_min, puma_threads_max

puma_env = ENV['RAILS_ENV']
puma_env = 'development' if puma_env.blank?
environment puma_env

preload_app!

before_fork do
  DBSubscriber.instance.shutdown
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  DBSubscriber.instance.start if DBSubscriber.instance.subscriptions?
end
