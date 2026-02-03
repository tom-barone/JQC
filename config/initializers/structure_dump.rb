# frozen_string_literal: true

ActiveRecord::Tasks::DatabaseTasks.structure_dump_flags = [
  '--no-comments',          # removes "Dumped from..." / "Dumped by..." and other comment noise
  '--restrict-key=rails'    # makes \restrict deterministic (must be alphanumeric)
]
