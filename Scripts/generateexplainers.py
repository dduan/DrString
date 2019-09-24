#!/usr/bin/env python3

import sys
from glob import glob
from os import path

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} PATH_TO_EXPLAINER_MARKDOWN_DIRECTORY")
    exit(1)

line_template = '''
    "{id}": .init(
        id: "{id}",
        summary:      """
{summary}
                      """,
        rightExample: """
{good_example}
                      """,
        wrongExample: """
{bad_example}
                      """
    ),
'''
pad = "                      "


def pad_lines(text):
    lines = []
    for line in text.split('\n'):
        lines.append(pad + line)
    return '\n'.join(lines)


lines = []
paths = glob(path.join(sys.argv[1], 'E*.md'))
paths.sort()
for exp_path in paths:
    exp_id = path.split(exp_path)[1].split('.')[0]
    with open(exp_path) as exp_file:
        sections = exp_file.read().split("\n\n\n")
        title = sections[0][3:]
        summary = pad_lines(sections[1])

        bad_example = None
        good_example = None
        if len(sections) > 2:
            examples_content = sections[2].split("\n\n")
            bad_example = pad_lines(examples_content[1][9:-4].strip())
            good_example = pad_lines(examples_content[3][9:-4].strip())
    lines.append(line_template.format(id=exp_id, summary=summary, bad_example=bad_example, good_example=good_example))


body = '\n'.join(lines)
header = """
// DO NOT EDIT: this is generated by Scripts/generateexplainers.py

let explainers: [String: Explainer] = [
"""
footer = """
]
"""

print('\n'.join([header, body, footer]))
