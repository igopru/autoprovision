


#!/bin/bash

# Параметры подключения к базе данных
DB_USER="freepbxuser"
DB_PASS="you_password"
DB_NAME="asterisk"
DB_TABLE="endpoint_extensions"

# Запрос к базе данных
QUERY="SELECT ext, mac FROM $DB_TABLE"

# Выполнение запроса и обработка результата
mysql -u $DB_USER -p$DB_PASS -D $DB_NAME -e "$QUERY" | while read -r ext mac; do
# Пропускаем заголовок таблицы
if [[ "$ext" == "ext" ]]; then
continue
fi

# Обрезаем последние два символа из ext
EXTEN="${ext::-2}"
MAC="$mac"

# Путь к шаблону и целевому файлу
TEMPLATE="/tftpboot/example.xml"
TARGET="/tftpboot/cfg$MAC.xml"

# Копирование шаблона и замена меток
if [[ -f "$TEMPLATE" ]]; then
cp "$TEMPLATE" "$TARGET"
sed -i "s/MACADDR/$MAC/g" "$TARGET"
sed -i "s/EXTEN/$EXTEN/g" "$TARGET"
echo "Файл $TARGET успешно создан и обновлен."
else
echo "Шаблон $TEMPLATE не найден."
fi
