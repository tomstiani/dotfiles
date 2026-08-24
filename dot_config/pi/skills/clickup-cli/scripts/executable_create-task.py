#!/usr/bin/env python3

import argparse
import json
import os
import urllib.error
import urllib.request
from pathlib import Path

API = "https://api.clickup.com/api/v2"


def request(path: str, method: str = "GET", payload: dict | None = None) -> dict:
    req = urllib.request.Request(
        f"{API}{path}",
        data=json.dumps(payload).encode() if payload else None,
        headers={
            "Authorization": os.environ["CLICKUP_API_TOKEN"],
            "Content-Type": "application/json",
        },
        method=method,
    )
    try:
        with urllib.request.urlopen(req) as response:
            return json.load(response)
    except urllib.error.HTTPError as error:
        raise SystemExit(f"ClickUp API error {error.code}: {error.read().decode()}") from error


def main() -> None:
    parser = argparse.ArgumentParser(description="Create a top-level ClickUp task")
    parser.add_argument("list_id")
    parser.add_argument("title")
    parser.add_argument("--description-file", type=Path)
    parser.add_argument("--status")
    parser.add_argument("--assign-me", action="store_true")
    parser.add_argument("--yes", action="store_true", help="Confirm task creation")
    args = parser.parse_args()

    if not args.yes:
        raise SystemExit("Refusing to create task without --yes")

    payload: dict = {"name": args.title}
    if args.description_file:
        payload["description"] = args.description_file.read_text()
    if args.status:
        payload["status"] = args.status
    if args.assign_me:
        payload["assignees"] = [request("/user")["user"]["id"]]

    task = request(f"/list/{args.list_id}/task", "POST", payload)
    task_id = task["id"]
    print(f"Created {task.get('custom_id') or task_id}: {task['name']}")
    print(f"https://app.clickup.com/t/{task_id}")


if __name__ == "__main__":
    main()
