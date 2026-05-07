#!/usr/bin/env swift
//
// pbcopy-text.swift
// Reads UTF-8 plain text from stdin and copies it to the macOS
// pasteboard via NSPasteboard.setString — which correctly handles
// Supplementary Multilingual Plane characters (Mathematical Bold,
// Italic, etc.).
//
// macOS `pbcopy` has a bug: it re-encodes 4-byte UTF-8 sequences
// (SMP characters like U+1D400–U+1D7FF) into garbled bytes on the
// pasteboard. This helper avoids that by using AppKit directly.
//
// Usage:  echo "𝗕𝗼𝗹𝗱 text" | ./pbcopy-text.swift
//

import AppKit

let data = FileHandle.standardInput.readDataToEndOfFile()

guard !data.isEmpty else {
    fputs("Error: No input received on stdin.\n", stderr)
    exit(1)
}

guard let text = String(data: data, encoding: .utf8) else {
    fputs("Error: Input is not valid UTF-8.\n", stderr)
    exit(1)
}

let pb = NSPasteboard.general
pb.clearContents()
pb.setString(text, forType: .string)
