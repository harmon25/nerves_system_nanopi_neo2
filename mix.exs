defmodule NervesSystemNanoPiNeo2.MixProject do
  use Mix.Project

  @app :nerves_system_nanopi_neo2
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.6",
      compilers: Mix.compilers() ++ [:nerves_package],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: [loadconfig: [&bootstrap/1]],
      docs: [extras: ["README.md"], main: "readme"]
    ]
  end

  def application do
    []
  end

  defp bootstrap(args) do
    set_target()
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  defp nerves_package do
    [
      type: :system,
      artifact_sites: [
        # {:github_releases, "uptimedk/#{@app}"}
      ],
      build_runner_opts: build_runner_opts(),
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig"
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.7.0", runtime: false},
      {:nerves_system_br, "1.16.5", runtime: false},
      {:nerves_toolchain_aarch64_nerves_linux_gnu, "~> 1.4", runtime: false},
      {:nerves_system_linter, "~> 0.4.0", runtime: false},
      {:ex_doc, "~> 0.18", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Nerves System - NanoPi Neo2
    """
  end

  defp package do
    [
      maintainers: ["Troels Brødsgaard"],
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/uptimedk/#{@app}"}
    ]
  end

  defp package_files do
    [
      "boot.cmd",
      "CHANGELOG.md",
      "fwup-revert.conf",
      "fwup.conf",
      "fwup_include",
      # "LICENSE",
      "linux-4.19.defconfig",
      "mix.exs",
      "nerves_defconfig",
      "post-build.sh",
      "post-createfs.sh",
      "README.md",
      "rootfs_overlay",
      "uboot",
      "VERSION"
    ]
  end

  defp build_runner_opts() do
    if primary_site = System.get_env("BR2_PRIMARY_SITE") do
      [make_args: ["BR2_PRIMARY_SITE=#{primary_site}"]]
    else
      []
    end
  end

  defp set_target() do
    if function_exported?(Mix, :target, 1) do
      apply(Mix, :target, [:target])
    else
      System.put_env("MIX_TARGET", "#{@app}")
    end
  end
end
