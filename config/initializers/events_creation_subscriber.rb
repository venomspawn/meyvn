# frozen_string_literal: true

Events::CreationSubscriber.subscribe
DBSubscriber.instance.start
