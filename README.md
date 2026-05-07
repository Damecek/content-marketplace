# damecek-content-marketplace

A Claude Code plugin marketplace with content-creation plugins.

## Plugins

| Plugin | Description |
|---|---|
| [`linkedin-content`](./plugins/linkedin-content) | Workflow for LinkedIn content creation from any repo: claims → series → article → posts → image → repurpose. All outputs are grounded in repo facts. |

## Install

### Add this marketplace

In Claude Code:

```
/plugin marketplace add damecek/content-creation
```

Or, for local development of this marketplace itself:

```
/plugin marketplace add /Users/adam/IdeaProjects/content-creation
```

### Install a plugin

```
/plugin install linkedin-content@damecek-content-marketplace
```

### Use the plugin

The skills become slash commands prefixed with the plugin name. From any project where you want to generate content:

```
/linkedin-content:proof-pack
/linkedin-content:series-plan
/linkedin-content:article-plan
/linkedin-content:draft-article
/linkedin-content:draft-post 1
/linkedin-content:post-image 1
/linkedin-content:repurpose-post 1
```

See the [plugin README](./plugins/linkedin-content/README.md) for the full workflow.

## Local development

To iterate on a plugin in this repo without going through marketplace install:

```bash
claude --plugin-dir /Users/adam/IdeaProjects/content-creation/plugins/linkedin-content
```

Edits to `SKILL.md` files take effect after `/reload-plugins`.

## Layout

```
.
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest
└── plugins/
    └── linkedin-content/         # plugin
        ├── .claude-plugin/
        │   └── plugin.json       # plugin manifest
        ├── skills/               # one SKILL.md per skill
        ├── scripts/              # helper utilities (pbcopy)
        └── README.md
```
