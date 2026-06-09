<h3 align="center">AutoIt JsonC UDF</h3>
<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-00b7ff?style=flat-square&logo=spdx&logoColor=white">
  <img src="https://img.shields.io/github/stars/seanhaydongriffin/JsonC-UDF?style=flat-square&color=00eaff&logo=reverbnation&logoColor=white">
  <img src="https://img.shields.io/github/last-commit/seanhaydongriffin/JsonC-UDF?style=flat-square&color=009dff&logo=github">
  <img src="https://img.shields.io/badge/os-Windows-00c8ff?style=flat-square&logo=windows&logoColor=white">
  <img src="https://visitor-badge.laobi.icu/badge?page_id=seanhaydongriffin.JsonC-UDF&color=00eaff&style=flat-square">
  <img src="https://hits.sh/github.com/seanhaydongriffin/JsonC-UDF.svg?style=flat-square&color=00b7ff">
</p>

<p align="center">
  <a href="#description">Description</a> •
  <a href="#features">Features</a> •
  <a href="#requirements">Requirements</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#license">License</a> •
  <a href="#acknowledgements">Acknowledgements</a>
</p>

## Description

The JsonC UDF is a fast, lightweight, and fully self‑contained JSON library for AutoIt, built on top of the optimized json‑c v0.18 C library.

It provides a clean AutoIt interface for parsing, creating, modifying, and serializing JSON using the same high‑performance engine used in many production‑grade C applications.

The UDF embeds both x86 and x64 json‑c DLLs internally and automatically loads the correct one at runtime, so there are no external dependencies and no DLLs to distribute. Just include the UDF and start working with JSON immediately.

Key features:

    High‑performance JSON parsing and serialization via json‑c v0.18

    Embedded DLLs (x86 + x64) — no external files required

    Automatic architecture detection

    Full support for JSON objects, arrays, strings, numbers, booleans, and null

    Clean AutoIt wrappers for the modern json‑c API

    Safe memory handling and reference‑counting

    Updated examples demonstrating the new API and best practices

Ideal for automation frameworks, CDP tooling, data processing, and any AutoIt project that needs fast, reliable JSON support.

## Requirements

- AutoIt v3.3.16.0 or later  

## Getting Started

Try the examples from the main folder that demonstrate the UDF functions.

## License

Distributed under the MIT License. See [LICENSE] for more information.
