@echo off
set models_dir=./../../models_repo
rem copy models files
xcopy "%models_dir%/PaddleRec/multi_task/mmoe/." . /s /e /y /d

.\.run_ce.bat
