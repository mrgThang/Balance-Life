# Balance Life

## Lưu ý
Tạo branch các nhân, resolve conflict trước khi merge vào main branch

### Tạo branch cá nhân
```git checkout -b <BRANCH-NAME>```

### Resolve conflict trước khi merge vào main
```git checkout main```
```git pull origin main```
```git checkout <BRANCH-NAME>
```git merge main```
resolve your conflict
```git checkout main```
```git merge <BRANCH-NAME>

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
