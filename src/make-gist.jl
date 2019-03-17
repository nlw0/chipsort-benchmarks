using GitHub, JSON, PkgBenchmark

results = benchmarkpkg("ChipSort");

gist_json = JSON.parse(
            """
            {
            "description": "A benchmark for ChipSort",
            "public": false,
            "files": {
                "benchmark.md": {
                "content": "$(escape_string(sprint(export_markdown, results)))"
                }
            }
            }
            """
        )

myauth = GitHub.authenticate(ENV["GITHUB_AUTH"])

posted_gist = create_gist(auth=myauth, params=gist_json)
