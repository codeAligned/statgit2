require "logger"

# TODO only include this if the output platform supports colours
require "active_support/logger"
require "logger/colors"

LOG = Logger.new(STDOUT)

# Flush after every output
STDOUT.sync = true