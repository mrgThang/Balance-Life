# Balance Life

## Lưu ý
Tạo branch các nhân, resolve conflict trước khi merge vào main branch

### Tạo branch cá nhân
```git checkout -b <BRANCH-NAME>```

### Resolve conflict trước khi merge vào main
1. ```git checkout main```

2. ```git pull origin main```

3. ```git checkout <YOUR-BRANCH-NAME>```

4. ```git merge main```

5. resolve your conflict

6. ```git push origin <YOUR-BRANCH-NAME>```

7. Tạo pull request và merge vào main

## Project folder structure

- ```assets``` folder for image, icon
- ```lib``` folder for handling app logic
- ```tests``` folder for testing

### Folder tree

- lib/
    - main.dart
    - models/
        - food_model.dart
        - ingredient_model.dart
        - nutrient_model.dart
    - screens/
        - home_screen.dart
        - food_detail_screen.dart
        - nutrient_detail_screen.dart
    - widgets/
        - custom_button.dart
        - nutrient_card.dart
    - services/
        - api_service.dart
        - database_service.dart
    - utils/
        - constants.dart
    - theme/
        - app_theme.dart
    - routes.dart
    - app.dart
