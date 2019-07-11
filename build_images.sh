#!/bin/bash

# Script that enters each OS directory and builds a docker image for it.

cd Ubuntu-18.04
docker build -t ubuntu/18.04 .
