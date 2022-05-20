# about eCommerce.ai
eCommerce.ai is a complete end-to-end Data Science, Graph, AI/ML Analytics technology framework to support data gathering, mining, wrangling, analysis including visualization & performing AI/ML Analytics on data, with intent to understand, support and predict eCommerce operations to support daily business operations for small, medium and very large organizations.

    eCommerce.ai is an official project submitted as [Galp's Hackathon Retail 4.0](https://taikai.network/en/galp/hackathons/retail40) Hackathon project work.
---
## Galp's Hackathon Retail 4.0
start here:-> [https://amitxshukla.github.io/eCommerce.ai](https://amitxshukla.github.io/eCommerce.ai/)

- Main source code/example notebooks are `executed & included` in documentation published under GitHub gh-pages branch. `Best way to understand content on this project` is to go through gh-pages branch.
- Complete source code is also available under main [GitHub Branch](https://github.com/AmitXShukla/eCommerce.ai).

---

## Technologies
```sbtshell
Frontend: Julia 1.7.1
Backend: Oracle OCI Cloud, Oracle ADW (Autonomous data warehouse) | TigerGraph/Oracle Graph DB
Rest API: Julia, TGCloud RESTAPI
AI: Julia, FLUXml.ai, Oracle AutoML
```

---
## Implementation approach
eCommerce.ai takes a methodological business workflow approach (follow data) to solve this challenge.

**Step 1:**
    
    At first, a detail analysis (much of the work) is done to understand, define end-to-end source to pay, order to cash, procure to sell business operations.
    You will see, tons of examples included in this project, These examples resemble real life commercial good procurement to sales including payments, accruals, receiving and expenses etc.

**Step 2:**
    
    Next, 3rd part IOT data like, local community events, holiday calendars, long weekends, weathers, climatic conditions, type of data is gathered.

**Step 3:**
    
    Then all of this data is combined, cleaned and wrangled in a format which can be used in Analytics.

**Step 4:**
    
    Then after, following Analytics is run and made available (in form of Jupyter | Pluto notebooks) for business operations, KPI Dashboards and Executive dashboards. These KPIs help business leadership take effective operational intelligence decisions.

**Final deliverables**
    
    Ad-Hoc reports :    simple data queries
    Analytics:          Self service reporting, analytics & visualization
    Advance Analytics:  would | could | should
    Predictive Analytics:   train, test and predict KPIs
    Real time Analytics:    running analytics on real time data

---
## Assets | Folder | File Structure
```
    README.md:  start here

assets
    notebooks:  These notebooks can run standalone | Docker container
                There are Jupyter | Pluto version
                    Jupyter -> Standard notebooks
                    Pluto -> reactive, auto run , real time data refresh
    sampleData: small sample datasets
                please see, GitHub doesn't allow to upload big amounts of data.
    sampleData jupyter notebook -> This Julia notebook can bs used to to generate volume of commerce data.
    docs/src :  complete source code with executed samples
    docs/make.jlL   This file is used to generate HTML Documentation of code.
                    similar to Python Sphinx | readthedocs | Jupyter eBook
    src:    actual Julia eCommerce package
            -> There isn't much here, because all source code is included & executed as in-line documentation.

GitHub gh-pages branch
    This is main starting point of this project.
    start here:-> [https://amitxshukla.github.io/eCommerce.ai](https://amitxshukla.github.io/eCommerce.ai/)

```