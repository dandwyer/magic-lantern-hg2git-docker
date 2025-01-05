This repo uses Docker to convert the official
[Magic Lantern](https://www.magiclantern.fm)
[Mercurial repository](https://foss.heptapod.net/magic-lantern/magic-lantern/)
to a git repository where each commit references the Mercurial changeset hash
that spawned it. This is advantageous as forum messages and/or broken URL links
often refer to Mercurial changesets that are otherwise untraceable after
migration to git. This has mostly affected me as I have a Canon 7D and have had
difficulty figuring out the commit(s) where it was last supported.

I knowingly created this fork of other available options due to the following
perceived issues:
1. Last commit to
    [Mercurial repository](https://foss.heptapod.net/magic-lantern/magic-lantern/)
    was on 3/24/2021 at time of writing (almost 4 years old), with optics that
    most active development is now on various git forks
2. [magiclantern_hg_02](https://github.com/reticulatedpines/magiclantern_hg_02),
    maintains the most complete Mercurial history I have seen, but doesn't include
    Mercurial changeset hashes in the commits, obfuscating traceability.
    Additionally, this repo is not endorsed for development, but rather is framed
    as a historical reference.
3. [magiclantern_simplified](https://github.com/reticulatedpines/magiclantern_simplified)
    has a lot of great active development going on, but has truncated branches
    and history from the original repo, challenging ability to pick up from where
    various in progress branches left off.

Given above, intent is to seed a repo with entirety of Mercurial, rebase active
development progress onto it, so that there can be one Magic Lantern repo to rule
them all!
