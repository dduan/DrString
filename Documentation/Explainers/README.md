# DrString Explainers

Files in this folder is structured data.

Each error reported by the `check` command is associated with a explanation. Each file in this folder (except
this one) is named after the ID of an explanation. The command `explain` uses content of these files as data
source. Therefore, it's vital that they follow the set structure.


## The Structure

Each explainer is composed of the following _section_s:

* Title
* Description
* Bad example and a good example (optional)

Two empty lines separate each _section_.

The title must be a H2.

The description can have manylines but no two consecutive empty lines.

The examples start with a H3 saying "bad" or "good", followed by an empty line, followed by a block quoted
example "code". Examples are optional except both must be present or missing at the same time.

