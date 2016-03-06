module ProcessorHelper

  STRING_DIR_PROCESSORS_DEFAULT = 'processors'
  STRING_FILE_NAME_PROCESSOR_DEFAULT = 'processor.rb'

  def load_processor_for(test)
    processor_file_path = File.join(Rails.root, 'app', STRING_DIR_PROCESSORS_DEFAULT,
                                    test.identifier, STRING_FILE_NAME_PROCESSOR_DEFAULT)
    load processor_file_path
  end
end
