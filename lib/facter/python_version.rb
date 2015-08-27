# Make python versions available as facts

def get_python_version(executable)
  if Facter::Util::Resolution.which(executable)
    Facter::Util::Resolution.exec("#{executable} -V 2>&1").match(/^.*(\d+\.\d+\.\d+)$/)[1]
  end
end

Facter.add("python_version") do
  setcode do
    get_python_version 'python'
  end
end

Facter.add("python2_version") do
  setcode do
    python2_version = get_python_version 'python2'
    if python2_version.nil?
      default_version = get_python_version 'python'
      if !default_version.nil? and default_version.start_with?('2')
        python2_version = default_version
      end
    end
    python2_version
  end
end

Facter.add("python3_version") do
  setcode do
    get_python_version 'python3'
  end
end
