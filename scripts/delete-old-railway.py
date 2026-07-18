#!/usr/bin/env python3
"""Delete legacy v72 Railway service by domain. Supports project or workspace token."""
from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request

GRAPHQL = "https://backboard.railway.com/graphql/v2"
LEGACY_DOMAIN = os.environ.get("LEGACY_DOMAIN", "web-production-08d73.up.railway.app")


def gql(token: str, query: str, *, workspace: bool = False) -> dict:
    headers = {"Content-Type": "application/json"}
    if workspace:
        headers["Authorization"] = f"Bearer {token}"
    else:
        headers["Project-Access-Token"] = token
    req = urllib.request.Request(
        GRAPHQL,
        data=json.dumps({"query": query}).encode(),
        headers=headers,
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        return json.loads(resp.read())


def find_by_project_token(token: str) -> tuple[str, str, str]:
    meta = gql(token, "query { projectToken { projectId environmentId } }")
    project_id = meta["data"]["projectToken"]["projectId"]
    env_id = meta["data"]["projectToken"]["environmentId"]
    proj = gql(
        token,
        f'query {{ project(id: "{project_id}") {{ services {{ edges {{ node {{ id name serviceInstances {{ edges {{ node {{ domains {{ serviceDomains {{ domain }} }} }} }} }} }} }} }} }} }}',
    )
    return project_id, env_id, _pick_service(proj, project_id)


def find_by_workspace_token(token: str) -> tuple[str, str, str]:
    data = gql(
        token,
        "query { projects { edges { node { id name services { edges { node { id name serviceInstances { edges { node { id domains { serviceDomains { domain } } } } } } } } } } } }",
        workspace=True,
    )
    for proj in data["data"]["projects"]["edges"]:
        node = proj["node"]
        project_id = node["id"]
        for svc in node.get("services", {}).get("edges", []):
            service = svc["node"]
            for inst in service.get("serviceInstances", {}).get("edges", []):
                domains = inst["node"].get("domains", {}).get("serviceDomains", [])
                if any(d.get("domain") == LEGACY_DOMAIN for d in domains):
                    env_id = _production_env(token, project_id, workspace=True)
                    return project_id, env_id, service["id"]
    raise SystemExit(f"No service found for domain {LEGACY_DOMAIN}")


def _production_env(token: str, project_id: str, *, workspace: bool) -> str:
    proj = gql(
        token,
        f'query {{ project(id: "{project_id}") {{ environments {{ edges {{ node {{ id name }} }} }} }} }} }}',
        workspace=workspace,
    )
    for env in proj["data"]["project"]["environments"]["edges"]:
        if env["node"]["name"] == "production":
            return env["node"]["id"]
    return proj["data"]["project"]["environments"]["edges"][0]["node"]["id"]


def _pick_service(proj: dict, project_id: str) -> str:
    edges = proj["data"]["project"]["services"]["edges"]
    for svc in edges:
        for inst in svc["node"].get("serviceInstances", {}).get("edges", []):
            domains = inst["node"].get("domains", {}).get("serviceDomains", [])
            if any(d.get("domain") == LEGACY_DOMAIN for d in domains):
                return svc["node"]["id"]
    if len(edges) == 1:
        return edges[0]["node"]["id"]
    names = [e["node"]["name"] for e in edges]
    raise SystemExit(f"Could not match domain; services: {names}. Set LEGACY_SERVICE_ID.")


def delete_service(token: str, service_id: str, env_id: str, *, workspace: bool) -> dict:
    q = f'mutation {{ serviceDelete(id: "{service_id}", environmentId: "{env_id}") }}'
    return gql(token, q, workspace=workspace)


def main() -> int:
    project_token = os.environ.get("OLD_RAILWAY_TOKEN", "").strip()
    workspace_token = os.environ.get("RAILWAY_WORKSPACE_TOKEN", "").strip()
    legacy_service = os.environ.get("LEGACY_SERVICE_ID", "").strip()

    if workspace_token:
        print("Using RAILWAY_WORKSPACE_TOKEN (all projects)...")
        project_id, env_id, service_id = find_by_workspace_token(workspace_token)
        ws = True
        token = workspace_token
    elif project_token:
        print("Using OLD_RAILWAY_TOKEN (legacy project)...")
        project_id, env_id, service_id = find_by_project_token(project_token)
        ws = False
        token = project_token
    else:
        print("Set OLD_RAILWAY_TOKEN or RAILWAY_WORKSPACE_TOKEN", file=sys.stderr)
        return 1

    if legacy_service:
        service_id = legacy_service

    print(f"Project: {project_id}")
    print(f"Environment: {env_id}")
    print(f"Service: {service_id}")
    print(f"Deleting legacy service for {LEGACY_DOMAIN}...")
    result = delete_service(token, service_id, env_id, workspace=ws)
    print(json.dumps(result, indent=2))
    print(f"Verify: curl -I https://{LEGACY_DOMAIN}/")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except urllib.error.HTTPError as exc:
        print(exc.read().decode(), file=sys.stderr)
        raise SystemExit(1)
