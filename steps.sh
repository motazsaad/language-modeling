#!/usr/bin/env bash


nohup bash language-modeling/get_vocabs_greater_than_n.sh 10 train vocabs language-modeling &


bash language-modeling/run_build_lm.sh



