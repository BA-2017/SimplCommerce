#!/usr/bin/env bash
set -v
set -e

cd src/SimplCommerce.WebHost

dotnet restore

dotnet ef database update
