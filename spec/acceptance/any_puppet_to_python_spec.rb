require 'spec_helper_acceptance'

describe 'any_puppet_to_python function' do
  it 'works with no errors' do
    pp = <<-EOS
    class { 'python':
      ensure  => 'present',
      version => '3',
    }

    $var = {
      1     => 2,
      3     => [
        5,
        7,
        'bar'
      ],
      'foo' => 11,
    }
    file { '/tmp/foo.py':
      ensure  => file,
      mode    => '0755',
      content => inline_epp(@(PYTHON), { var => $var }),
        <%- |Any $var| -%>
        #!/usr/bin/env python3
        var = <%= $var.any_puppet_to_python() %>
        print(var[1] + var[3][1] + var["foo"])
        print(var[3][2] * var[3][0])
        | PYTHON
    }
    EOS

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)

    expect(shell('/tmp/foo.py').stdout).to eq("20\nbarbarbarbarbar\n")
  end
end
