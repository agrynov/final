import random

def guess_the_number():
    target_number = random.randint(1, 100)
    attempts = 5  

    print("Вгадайте число від 1 до 100. У вас є 5 спроб.")

    for attempt in range(1, attempts + 1):
        try:
           
            user_guess = int(input(f"Введіть число: "))

            if user_guess == target_number:
                print("Вітаємо! Ви вгадали правильне число!")
                return 
            elif user_guess < target_number:
                print("Занадто низько")
            else:
                print("Занадто високо")
        except ValueError:
            print("Будь ласка, введіть ціле число.")
    
   
    print(f"Вибачте, у вас закінчилися спроби. Правильний номер був {target_number}.")
guess_the_number()