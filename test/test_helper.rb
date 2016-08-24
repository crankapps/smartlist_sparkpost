$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'smartlist_sparkpost'

require 'active_support'
require 'active_support/time'
require 'active_support/concern'

require 'minitest/autorun'
require 'minitest/unit'
require 'mocha/mini_test'
require 'webmock/test_unit'
require 'webmock/minitest'