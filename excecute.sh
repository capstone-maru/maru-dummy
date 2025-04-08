DB_NAME=maru
DB_USER= # 데이터베이스 사용자 이름
# local : maru
DB_HOST=  # 로컬에서 실행할 경우 'localhost'로 설정 
# localhoat : localhost
DB_PORT=5432  
# 기본 포트는 5432
DB_PASSWORD=
# local : 0810
SQL_DIRECTORY=~/Desktop/test  # SQL 파일들이 있는 디렉터리 경로

# 환경 변수 설정 (비밀번호를 입력하지 않으려면)
export PGPASSWORD=$DB_PASSWORD

SQL_FILES=("card_feature.sql" "profile_image.sql" "member_account.sql" 
"room_info.sql" "studio_post.sql" "dormitory_post.sql" "room_image.sql" "view_post.sql" "participation")

# 트랜잭션 시작
echo "BEGIN;" > $SQL_DIRECTORY/transaction.sql

# 모든 .sql 파일을 순차적으로 실행
for SQL_FILE in "${SQL_FILES[@]}"; do
    cat "$SQL_DIRECTORY/$SQL_FILE" >> $SQL_DIRECTORY/transaction.sql
    echo "" >> $SQL_DIRECTORY/transaction.sql
done

# 트랜잭션 커밋
echo "COMMIT;" >> $SQL_DIRECTORY/transaction.sql

# 트랜잭션 파일 실행
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -p $DB_PORT -f "$SQL_DIRECTORY/transaction.sql"

# 실행 결과 출력
if [ $? -eq 0 ]; then
    echo "All SQL files executed successfully and committed."
else
    echo "Error occurred. Rolling back."
fi

# 임시 트랜잭션 파일 삭제
rm "$SQL_DIRECTORY/transaction.sql"

# PGPASSWORD 환경 변수 삭제
unset PGPASSWORD

echo "All SQL files have been executed."
