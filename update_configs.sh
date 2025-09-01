#!/bin/bash

# Параметры подключения к базе данных
DB_USER="freepbxuser"
DB_PASS="you_password"
DB_NAME="asterisk"
DB_TABLE="endpoint_extensions"

# Запрос к базе данных
QUERY="SELECT ext, mac FROM $DB_TABLE"

mysql -u $DB_USER -p$DB_PASS -D $DB_NAME -e "$QUERY" | while read -r ext mac; do
    if [[ "$ext" == "ext" ]]; then
        continue
    fi

    EXTEN="${ext::-2}"
    MAC="$mac"
    TEMPLATE="/tftpboot/example.xml"
    TARGET="/tftpboot/cfg$MAC.xml"

    if [[ -f "$TEMPLATE" ]]; then
        cp "$TEMPLATE" "$TARGET"
        sed -i "s/MACADDR/$MAC/g" "$TARGET"
        sed -i "s/EXTEN/$EXTEN/g" "$TARGET"
        echo "Файл $TARGET успешно создан."
    else
        echo "Шаблон $TEMPLATE не найден."
    fi
done
