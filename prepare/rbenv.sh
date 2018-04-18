#!/bin/bash

if [ ! -e $RBENV_ROOT ] ;then
  echo "start install rbenv..."
  git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT
  git clone https://github.com/sstephenson/ruby-build.git $RBENV_ROOT/plugins/ruby-build
fi