. as $root |
($root.packages[]? | select(.name == "arduino")) as $arduino_pkg |
([$arduino_pkg.platforms[]? | select(.architecture == "avr") | .toolsDependencies[]? | "\(.name)|\(.version)"] | unique) as $needed_tool_specs |
($root.packages[]? | select(.name == "builtin")) as $builtin_pkg |
{
    packages: [
        {
            name: $arduino_pkg.name,
            platforms: [
                ($arduino_pkg.platforms[]? | select(.architecture == "avr")) | {
                    name: .name,
                    architecture: .architecture,
                    version: .version,
                    url: .url,
                    archiveFileName: .archiveFileName,
                    checksum: .checksum,
                    toolsDependencies: .toolsDependencies
                }
            ] | if length > 0 then [.[0]] else [] end,
            tools: (
                ($arduino_pkg.tools // []) |
                map(select("\(.name)|\(.version)" as $spec | $needed_tool_specs | index($spec) != null)) |
                map({
                    name: .name,
                    version: .version,
                    systems: (
                        (.systems // []) |
                        map(select(.host == "x86_64-linux-gnu")) |
                        map({
                            host: .host,
                            url: .url,
                            archiveFileName: .archiveFileName,
                            checksum: .checksum,
                        })
                    )
                })
            )
        },
        {
            name: $builtin_pkg.name,
            platforms: $builtin_pkg.platforms,
            tools: (
                ($builtin_pkg.tools // []) |
                map(select(.name | test("discovery|ctags"; "i"))) |
                map({
                    name: .name,
                    version: .version,
                    systems: (
                        (.systems // []) |
                        map(select(.host == "x86_64-pc-linux-gnu")) |
                        map({
                            host: .host,
                            url: .url,
                            archiveFileName: .archiveFileName,
                            checksum: .checksum,
                        })
                    )
                })
            )
        }
    ]
}

