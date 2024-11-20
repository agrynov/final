#!/bin/bash

random_number=$(( RANDOM % 100 + 1 ))
max_attempts=5

check_guess() {
  local guess="$1"
  if [ "$guess" -eq "$random_number" ]; then
    echo "Вітаємо! Ви вгадали правильне число."
    exit 0
  elif [ "$guess" -gt "$random_number" ]; then
    echo "Занадто високо!"
  else
    echo "Занадто низько!"
  fi
}

for (( attempt=1; attempt <= max_attempts; attempt++ )); do
  read -p "Введіть число (від 1 до 100): " guess
  check_guess "$guess"
done

echo "Вибачте, у вас закінчилися спроби. Правильним числом було $random_number"