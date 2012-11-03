# The main LazyLocalize driver
class LazyLocalize
  # Add localization comments back into Objective C code!
    #
    # Example:
    #   >> LazyLocalize.extractCommentsAndAddToCode("./*.m", "./Resources/en.lproj/Localizable.strings")
    #
    # Arguments:
    #   codeFilePath: (String)
    #   stringFilePath: (String)
    
  def self.extractCommentsAndAddToCode(codeFilePath = '*.m', stringFilePath = 'Localizable.strings')
    stringsHash = Hash.new
    fd = File.open(stringFilePath, "rb")
    while line = fd.gets
        if line.include?("/* ")
          key = fd.gets.split(' = ').first.gsub("\"", "")
          stringsHash[key] = line.sub("/* ", "").sub(" */", "").strip
        end
    end
    fd.close

    Dir.glob(codeFilePath) do |fileName|
      puts fileName
      code = IO.read(fileName)

      stringsHash.each {|key, comment|
        code.gsub!( "NSLocalizedString\(@\"#{key}\", @\"\"\)", "NSLocalizedString\(@\"#{key}\", @\"#{comment}\"\)" );
      }
  
      File.open(fileName, 'w') {|f| f.write(code) }
    end
  end
end
