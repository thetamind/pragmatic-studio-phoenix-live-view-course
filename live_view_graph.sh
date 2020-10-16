#!/bin/sh

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit

elixir -r priv/live_view_graph.ex -S mix live_view.graph
