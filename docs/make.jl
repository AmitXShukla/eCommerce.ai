push!(LOAD_PATH, "../src/")
using Documenter, eCommerce

makedocs(sitename="eCommerce.ai",
    pages=[
        "Introduction" => "index.md",
        "Demo" => "demo.md",
        "Implementation" => "architecture.md",
        "Data sets" => "data.md",
        "IOTs" => "iot.md",
        "AI/ML Analytics" => "analytics.md"
    ])