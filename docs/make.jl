push!(LOAD_PATH, "../src/")
using Documenter, eCommerce

makedocs(sitename = "eCommerce.ai",
    pages=[
    "Introduction" => "index.md",
    "Demo" => "demo.md",
    "Implementation" => 
    [
        "Architecture" => "architecture.md",
        "Business Process" => "process.md",
        "ERD" => "erd.md",
        "Explainable AI" => "explain.md"
    ],
    "Data sets" => "data.md",
    "IOTs" => "iot.md",
    "AI/ML Analytics" => 
        [
    "Self-service" => "analytics.md"
    "Ad-hoc" => "adhoc.md"
    "Advance" => "advance.md"
    "Predictive" => "prediction.md"
    "Realtime" => "realtime.md"
        ]
])