"""Fail closed before building/publishing an explicitly approved web revision."""
import argparse
import os
from pathlib import Path
import re
import subprocess


def authorize(*, root: Path, revision: str, tag: str, approved: str,
              event: str, ref: str) -> str:
    if event != "workflow_dispatch" or ref != "refs/heads/develop" or approved != "true":
        raise ValueError("Web publication needs explicit approval from the develop workflow.")
    if not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise ValueError("Approve the complete lowercase source SHA.")
    try:
        actual = subprocess.check_output(
            ["git", "rev-parse", f"{revision}^{{commit}}"], cwd=root,
            text=True, stderr=subprocess.DEVNULL).strip()
        ancestor = subprocess.run(
            ["git", "merge-base", "--is-ancestor", revision, "origin/develop"],
            cwd=root, check=False, stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL).returncode
        pubspec = subprocess.check_output(
            ["git", "show", f"{revision}:pubspec.yaml"], cwd=root,
            text=True, stderr=subprocess.DEVNULL)
    except (OSError, subprocess.CalledProcessError) as error:
        raise ValueError("The approved source is unavailable.") from error
    if actual != revision or ancestor != 0:
        raise ValueError("The approved source must already be integrated into develop.")
    version = re.search(r"^version:\s*(\d+\.\d+\.\d+)\+\d+\s*$", pubspec, re.MULTILINE)
    if not version or tag != f"v{version.group(1)}":
        raise ValueError("The release tag does not match the approved source version.")
    return revision


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--revision", required=True)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--approved", required=True)
    args = parser.parse_args()
    try:
        revision = authorize(root=Path.cwd(), revision=args.revision,
                             tag=args.tag, approved=args.approved,
                             event=os.environ.get("GITHUB_EVENT_NAME", ""),
                             ref=os.environ.get("GITHUB_REF", ""))
    except ValueError as error:
        parser.exit(1, f"Publication blocked: {error}\n")
    print(f"Approved source: {revision}")


if __name__ == "__main__":
    main()
